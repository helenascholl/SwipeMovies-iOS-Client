import UIKit

class TableViewController: UITableViewController {
    
    let queue = DispatchQueue(label: "download")
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue.async {
            if let url = self.getTMDbUrl(page: 1) {
                self.downloadMovies(url)
            } else {
                print("Cannot resolve URL")
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath)
        cell.textLabel?.text = movies[indexPath.row].title

        return cell
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
                    self.tableView.reloadData()
                }
            }
        } else {
            print("Download failed")
        }
    }
    
}
