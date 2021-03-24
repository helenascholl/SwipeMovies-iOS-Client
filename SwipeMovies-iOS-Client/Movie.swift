class Movie {
    
    init(_ id: Int, _ title: String, _ description: String, _ posterUrl: String) {
        self.id = id
        self.title = title
        self.description = description
        self.posterUrl = posterUrl
    }
    
    var id: Int
    var title: String
    var description: String
    var posterUrl: String
    
}

enum SwipeDirection {
    
    case left
    case right
    
}

class SwipedMovie {
    
    init(_ movie: Movie, _ swipeDirection: SwipeDirection) {
        self.movie = movie
        self.swipeDirection = swipeDirection
    }
    
    var movie: Movie
    var swipeDirection: SwipeDirection
    
}
