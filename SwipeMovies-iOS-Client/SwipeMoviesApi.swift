import UIKit

class SwipeMoviesApi {
    
    private static var instance: SwipeMoviesApi?
    private var user: User?
    
    private init() {
        user = User(0, "Test")
    }

    public static func getInstance() -> SwipeMoviesApi {
        if instance === nil {
            instance = SwipeMoviesApi()
        }
        
        return instance!
    }
    
    public func createGroup(_ name: String, _ callback: @escaping (_ group: Group) -> Void) {
        if let url = URL(string: "\(getBackendUrl())/api/groups") {
            let json: [String: Any] = [
                "name": name
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                var request = URLRequest(url: url)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, _, _) -> Void in
                    if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let group = Group(json["id"] as! Int, json["name"] as! String)
                        callback(group)
                    }
                })
                task.resume()
            }
        }
    }
    
    public func joinGroup(_ id: Int, _ callback: @escaping () -> Void) {
        if let user = user, let url = URL(string: "\(getBackendUrl())/api/users/\(user.id)/groups") {
            let json: [String: Any] = [
                "id": id
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                var request = URLRequest(url: url)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request, completionHandler: { (_, _, _) -> Void in
                    callback()
                })
                task.resume()
            }
        }
    }
    
    private func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
