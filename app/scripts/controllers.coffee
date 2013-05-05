SF.LoginController = Ember.ObjectController.extend
  isError: false
  username: null
  password: null
  content: {}
  tryLogin: (auto) ->
    that = this
    SF.api "auth", "POST", {email:@username,password:@password}, (response) ->
      if response.user
        user = SF.User.create()
        user.setUserProperties response.user
        SF.loginController.set 'content', user
        SF.loginController.set 'username', user.email
        SF.loginController.set 'password', user.password
        SF.loginController.set 'id', user.id
        localStorage.setItem 'username', user.email
        localStorage.setItem 'password', user.password
        localStorage.setItem 'id', user.id
        SF.loginController.set 'isError', false
        unless auto then that.transitionToRoute 'songs'
      else unless auto
        SF.loginController.set 'isError', true
        SF.loginController.set 'password', null

SF.loginController = SF.LoginController.create()

SF.MySongsController = Ember.ArrayController.extend
  songs: []

SF.SongsController = Ember.ArrayController.extend
  songs: []
  leastRated: ->
    console.log "needs work"

SF.UploadController = Ember.ObjectController.extend
  content: {}
  name: null
  artist: null
  description: null
  src: null
  genre: null
  agreeToTerms: false
  hasNotAgreed: Ember.computed.not('agreeToTerms')
  tryUpload: ->
    SF.Song.new
      song:
        sfid: new Date().getTime()
        user: SF.loginController.get('content.id')
        name: @name
        artist: @artist
        description: @description 
        file: "figureOutLater"
        genre: @genre
        date: new Date()
        
SF.PlayerController = Ember.ObjectController.extend
  content: null
  playSong: (song) ->
    @set('content', song)

SF.playerController = SF.PlayerController.create()
        
