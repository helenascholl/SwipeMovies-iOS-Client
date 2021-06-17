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
    
    public func getGroups(_ callback: @escaping (_ groups: [Group]) -> Void) {
        var groups: [Group] = []
        
        if let user = user, let url = URL(string: "\(getBackendUrl())/api/users/\(user.id)/groups") {
            if let data = try? Data(contentsOf: url) {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []), let array = json as? [Any] {
                    for obj in array {
                        if let dict = obj as? [String: Any] {
                            let group = Group(dict["id"] as! Int, dict["name"] as! String)
                            groups.append(group)
                        }
                    }
                    
                    callback(groups)
                }
            } else {
                print("Download failed")
            }
        } else {
            print("Cannot resolve URL")
        }
    }
    
    public func postSwipedMovie(_ swipedMovie: SwipedMovie) {
        if let user = user, let url = URL(string: "\(getBackendUrl())/api/users/\(user.id)/movies/swiped") {
            let json: [String: Any] = [
                "movie": [
                    "id": swipedMovie.movie.id,
                    "title": swipedMovie.movie.title,
                    "description": swipedMovie.movie.description,
                    "posterUrl": swipedMovie.movie.posterUrl
                ],
                "swipeDirection": swipedMovie.swipeDirection == .right ? "right" : "left"
            ]
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: json) {
                var request = URLRequest(url: url)
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                request.httpMethod = "POST"
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request)
                task.resume()
            }
        }
    }
    
    private func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
