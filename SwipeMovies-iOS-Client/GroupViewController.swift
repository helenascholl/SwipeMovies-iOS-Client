import UIKit

class GroupViewController: UITableViewController {
    
    var groups: [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwipeMoviesApi.getInstance().getGroups({ (_ groups: [Group]) -> Void in
            DispatchQueue.main.async {
                self.groups = groups
                self.tableView.reloadData()
            }
        })
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "group", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row].name

        return cell
    }
    
    func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
