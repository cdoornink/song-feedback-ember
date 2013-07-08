SF.LoginController = Ember.ObjectController.extend
  isError: false
  username: null
  password: null
  content: 
    reviews: []
    songs: []
  canUpload: false
  reviewsLeftBeforeUpload: 0
  
  tryLogin: (auto) ->
    that = this
    pass = md5(@password) if @password
    SF.api "auth", "POST", {email:@username,password:pass}, (response) ->
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