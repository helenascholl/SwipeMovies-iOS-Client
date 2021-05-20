class SwipeMoviesApi {
    
    private static var instance: SwipeMoviesApi?
    
    private init() {}

    static func getInstance() -> SwipeMoviesApi {
        if instance === nil {
            instance = SwipeMoviesApi()
        }
        
        return instance!
    }

}
