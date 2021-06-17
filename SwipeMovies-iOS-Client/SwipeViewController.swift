import UIKit

class SwipeViewController: UIViewController {
    
    let queue = DispatchQueue(label: "download")
    let posterBaseUrl = "https://image.tmdb.org/t/p/w200"
    
    var movies: [Movie] = []
    var currentIndex: Int = -1
    var currentPage: Int = 1
    var swipedRight: [Movie] = []
    var swipedLeft: [Movie] = []

    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!

    @IBAction func buttonRight(_ sender: Any) {
        swipeRight()
    }
    
    @IBAction func buttonLeft(_ sender: Any) {
        swipeLeft()
    }
    
    @IBAction func swipeGestureRight(_ sender: Any) {
        swipeRight()
    }
    
    @IBAction func swipeGestureLeft(_ sender: Any) {
        swipeLeft()
    }
    
    func swipeRight() {
        if currentIndex >= 0 {
            swipedRight.append(movies[currentIndex])
            SwipeMoviesApi.getInstance().postSwipedMovie(SwipedMovie(movies[currentIndex], .right))
            showNextMovie()
        }
    }
    
    func swipeLeft() {
        if currentIndex >= 0 {
            swipedLeft.append(movies[currentIndex])
            SwipeMoviesApi.getInstance().postSwipedMovie(SwipedMovie(movies[currentIndex], .left))
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
    
    func addNewMovies(_ callback: @escaping () -> ()) {
        SwipeMoviesApi.getInstance().getMovies({ (_ movies: [Movie]) -> Void in
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movies)
                callback()
            }
        })
    }
    
    func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
