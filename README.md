# SwipeMovies-iOS-Client

A client for [SwipeMovies-Server](https://github.com/schollsebastian/SwipeMovies-Server).

## Configuration

Copy the file `auth.xcconfig.template`, call it `auth.xcconfig` and change the `BACKEND_URL` to your backend URL. Escape `//` with `/$()/`.

### Getting an API Key

For the application to work properly you need a
[TMDb API Key](https://developers.themoviedb.org/3/getting-started/introduction).

After obtaining your API key, paste it into `auth.xcconfig`.
