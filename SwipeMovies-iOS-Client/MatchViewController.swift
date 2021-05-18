import UIKit

class MatchViewController: UITableViewController {
    
    var matches: [Match] = []
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.download()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "match", for: indexPath)
        
        var detailText = ""
        
        for user in matches[indexPath.row].users {
            detailText += "\(user.username), "
        }
        
        cell.textLabel?.text = matches[indexPath.row].movie.title
        cell.detailTextLabel?.text = String(detailText.dropLast(2))

        return cell
    }
    
    func download() {
        var downloadedMatches: [Match] = []
        
        if let url = URL(string: "\(getBackendUrl())/api/users/\(userId)/matches") {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let array = json as? [Any] {
                    for obj in array {
                        if let dict = obj as? [String: Any] {
                            if let movie = dict["movie"] as? [String: Any] {
                                let match = Match(Movie(movie["id"] as! Int, movie["title"] as! String, movie["description"] as! String, movie["posterUrl"] as! String))
                                
                                if let users = dict["users"] as? [Any] {
                                    for userObj in users {
                                        if let user = userObj as? [String: Any] {
                                            match.addUser(User(user["id"] as! Int, user["username"] as! String))
                                        }
                                    }

                                    downloadedMatches.append(match)
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.matches = downloadedMatches
                        self.tableView.reloadData()
                    }
                }
            } else {
                print("Download failed")
            }
        } else {
            print("Cannot resolve URL")
        }
        
    }
    
    func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
