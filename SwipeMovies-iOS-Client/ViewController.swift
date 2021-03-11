import UIKit

class ViewController: UIViewController {
    
    let queue = DispatchQueue(label: "download")
    var movies: [Movie] = []
    var currentIndex: Int?
    var swipedRight: [Movie] = []
    var swipedLeft: [Movie] = []

    @IBOutlet weak var movieTitle: UILabel!
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            print("right")
        }
        
        if let index = currentIndex {
            print("Swiped right: \(movies[index].title)")
            swipedRight.append(movies[index])
        }
    }
    
    override func viewDidLoad() {
        self.view.isUserInteractionEnabled = true
        super.viewDidLoad()

        queue.async {
            if let url = self.getTMDbUrl(page: 1) {
                self.downloadMovies(url)
            } else {
                print("Cannot resolve URL")
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
    
    func downloadMovies(_ url: URL) {
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
                    self.movies = downloadedMovies
                    self.currentIndex = 0
                    self.movieTitle.text = downloadedMovies[self.currentIndex!].title
                }
            }
        } else {
            print("Download failed")
        }
    }

}
