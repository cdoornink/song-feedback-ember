SF.LoginController = Ember.ObjectController.extend
  isError: false
  username: null
  password: null
  content: {}
  tryLogin: (auto) ->
    console.log (auto ? "auto login" : "try login")
    that = this
    SF.api "auth", "POST", {email:@username,password:@password}, (response) ->
      if response.user
        user = SF.User.create()
        user.setUserProperties(response.user)
        SF.loginController.set('content', user)
        localStorage.setItem('username', user.email)
        localStorage.setItem('password', user.password)
        localStorage.setItem('id', user.id)
        SF.loginController.set('isError', false)
        unless auto
          that.transitionToRoute('songs')
      else if (!auto)
        SF.loginController.set('isError', true)
        SF.loginController.set('password', null)

SF.loginController = SF.LoginController.create()

SF.MySongsController = Ember.ArrayController.extend
  songs: []

SF.SongsController = Ember.ArrayController.extend
  songs: []
  leastRated: ->
    newSong = 
      song:
        sfid: "10"
        user: "1"
        name: "I'm making progress"
        artist: "Rejuvinilezzz"
        file: null
        description: "I am free of ember data shackles..."
        genre: "Poop Pop"
        reviews:
          overall: 8
          vocals: 6
          songwriting: 5
          musicianship: 4
          creativity: 6
          production: 5
          date: new Date()        
        date: new Date()
    console.log(newSong)
    SF.Song.new(newSong)
