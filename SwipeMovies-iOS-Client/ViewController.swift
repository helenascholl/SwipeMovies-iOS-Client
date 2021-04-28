import UIKit

class ViewController: UIViewController {
    
    let userId = 0
    
    @IBOutlet weak var joinGroupText: UITextField!
    @IBOutlet weak var createGroupText: UITextField!
    
    @IBAction func joinGroupButton(_ sender: Any) {
        if let id = joinGroupText.text, let url = URL(string: "\(getBackendUrl())/api/users/\(userId)/groups") {
            let json: [String: Any] = [
                "id": id
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                var request = URLRequest(url: url)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request)
                task.resume()
                
                joinGroupText.text = ""
            }
        }
    }
    
    @IBAction func createGroupButton(_ sender: Any) {
        if let name = createGroupText.text, let url = URL(string: "\(getBackendUrl())/api/groups") {
            let json: [String: Any] = [
                "name": name
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                var request = URLRequest(url: url)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request)
                task.resume()
                
                createGroupText.text = ""
            }
        }
    }
    
    @IBAction func showSwipe(_ sender: Any) {
        performSegue(withIdentifier: "swipe", sender: self)
    }
    
    func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }
    
}
