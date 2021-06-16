import UIKit

class GroupViewController: UITableViewController {
    
    var groups: [Group] = []
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.download()
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
    
    func download() {
        var downloadedGroups: [Group] = []
        
        if let url = URL(string: "\(getBackendUrl())/api/users/\(userId)/groups") {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let array = json as? [Any] {
                    for obj in array {
                        if let dict = obj as? [String: Any] {
                            let group = Group(dict["id"] as! Int, dict["name"] as! String)
                            downloadedGroups.append(group)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.groups = downloadedGroups
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
