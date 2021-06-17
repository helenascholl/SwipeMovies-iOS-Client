import UIKit

class MatchViewController: UITableViewController {
    
    var matches: [Match] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwipeMoviesApi.getInstance().getMatches({ (_ matches: [Match]) -> Void in
            self.matches = matches
            self.tableView.reloadData()
        })
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
    
    func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
