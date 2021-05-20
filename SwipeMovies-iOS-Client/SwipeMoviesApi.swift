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
    
    private func getBackendUrl() -> String {
        return Bundle.main.infoDictionary?["Backend URL"] as! String
    }

}
