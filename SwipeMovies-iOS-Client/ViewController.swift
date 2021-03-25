import UIKit

class ViewController: UIViewController {
    
    let queue = DispatchQueue(label: "download")
    let posterBaseUrl = "https://image.tmdb.org/t/p/w200"
    let userId = "test"
    
    var movies: [Movie] = []
    var currentIndex: Int = -1
    var currentPage: Int = 1
    var swipedRight: [Movie] = []
    var swipedLeft: [Movie] = []

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!

    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if currentIndex >= 0 {
            print("Swiped right: \(movies[currentIndex].title)")
            swipedRight.append(movies[currentIndex])
            postSwipedMovie(SwipedMovie(movies[currentIndex], .right))
            showNextMovie()
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if currentIndex >= 0 {
            print("Swiped left: \(movies[currentIndex].title)")
            swipedLeft.append(movies[currentIndex])
            postSwipedMovie(SwipedMovie(movies[currentIndex], .left))
            showNextMovie()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewMovies() {
            self.currentPage += 1
            self.showNextMovie()
        }
    }
    
    func showNextMovie() {
        currentIndex += 1
        
        if currentIndex == movies.count - 3 {
            addNewMovies() {
                self.currentPage += 1
            }
        }
        
        moviePoster.image = nil
        movieTitle.text = movies[currentIndex].title
        movieDescription.text = movies[currentIndex].description
        
        queue.async {
            let posterUrl = URL(string: self.movies[self.currentIndex].posterUrl)
            let imageData = try! Data(contentsOf: posterUrl!)
            
            DispatchQueue.main.async {
                self.moviePoster.image = UIImage(data: imageData)
            }
        }
    }
    
    func getTMDbUrl(page: Int) -> URL? {
        let urlString = "https://api.themoviedb.org/3/trending/movie/week?api_key=\(getTMDbApiKey())&page=\(page)"
        
        return URL(string: urlString)
    }
    
    func getTMDbApiKey() -> String {
        return Bundle.main.infoDictionary?["TMDb API Key"] as! String
    }
    
    func addNewMovies(_ callback: @escaping () -> ()) {
        queue.async {
            if let url = self.getTMDbUrl(page: self.currentPage) {
                self.downloadMovies(url, callback)
            } else {
                print("Cannot resolve URL")
            }
        }
    }
    
    func downloadMovies(_ url: URL, _ callback: @escaping () -> ()) {
        if let data = try? Data(contentsOf: url) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let movies = json["results"] as? [Any] {
                var downloadedMovies: [Movie] = []
                
                for movie in movies {
                    if let dict = movie as? [String: Any] {
                        let id = dict["id"] as! Int
                        let title = dict["title"] as! String
                        let description = dict["overview"] as! String
                        let posterUrl = posterBaseUrl + (dict["poster_path"] as! String)
                        
                        downloadedMovies.append(Movie(id, title, description, posterUrl))
                    }
                }
                
                DispatchQueue.main.async {
                    self.movies.append(contentsOf: downloadedMovies)
                    callback()
                }
            }
        } else {
            print("Download failed")
        }
    }
    
    func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }
    
    func postSwipedMovie(_ swipedMovie: SwipedMovie) {
        if let url = URL(string: "\(getBackendUrl())/api/users/\(userId)/movies") {
            let json: [String: Any] = [
                "movie": [
                    "id": swipedMovie.movie.id,
                    "title": swipedMovie.movie.title,
                    "description": swipedMovie.movie.description,
                    "posterUrl": swipedMovie.movie.posterUrl
                ],
                "swipeDirection": swipedMovie.swipeDirection == .right ? "right" : "left"
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                var request = URLRequest(url: url)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request)
                task.resume()
            }
        }
    }

}
