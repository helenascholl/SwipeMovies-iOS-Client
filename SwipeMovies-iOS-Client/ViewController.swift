import UIKit

class ViewController: UIViewController {
    
    let queue = DispatchQueue(label: "download")
    var movies: [Movie] = []
    var currentIndex: Int = -1
    var currentPage: Int = 1
    var swipedRight: [Movie] = []
    var swipedLeft: [Movie] = []

    @IBOutlet weak var movieTitle: UILabel!
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if currentIndex >= 0 {
            print("Swiped right: \(movies[currentIndex].title)")
            swipedRight.append(movies[currentIndex])
            showNextMovie()
        }
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if currentIndex >= 0 {
            print("Swiped left: \(movies[currentIndex].title)")
            swipedLeft.append(movies[currentIndex])
            showNextMovie()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNewMovies() {
            self.currentIndex += 1
            self.currentPage += 1
            self.movieTitle.text = self.movies[self.currentIndex].title
        }
    }
    
    func showNextMovie() {
        currentIndex += 1
        
        if currentIndex == movies.count - 3 {
            addNewMovies() {
                self.currentPage += 1
            }
        }
        
        movieTitle.text = movies[currentIndex].title
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
                        let title = dict["title"] as! String
                        let overview = dict["overview"] as! String
                        
                        downloadedMovies.append(Movie(title, overview))
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

}
