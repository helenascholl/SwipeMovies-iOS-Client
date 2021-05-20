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
    
    public func createGroup(_ name: String, _ callback: @escaping () -> Void) {
        if let user = user, let url = URL(string: "\(getBackendUrl())/api/groups") {
            let json: [String: Any] = [
                "user": [
                    "id": user.id
                ],
                "group": [
                    "name": name
                ]
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
