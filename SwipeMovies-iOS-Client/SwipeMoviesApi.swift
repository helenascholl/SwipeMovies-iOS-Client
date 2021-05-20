class SwipeMoviesApi {
    
    private static var instance: SwipeMoviesApi?
    
    private init() {}

    public static func getInstance() -> SwipeMoviesApi {
        if instance === nil {
            instance = SwipeMoviesApi()
        }
        
        return instance!
    }

}
