@SF = Ember.Application.create()

SF.Router.map ->
  @resource 'login'
  @resource 'logout'
  @resource 'songs'
  @resource 'song', {path:'/songs/:song_id'}
  @resource 'my-songs'
  @resource 'upload'
  @resource 'settings'
  @resource 'terms'
  @resource 'signup'

SF.ApplicationRoute = Ember.Route.extend
  enter: ->
    SF.loginController.set 'username', localStorage.getItem('username')
    SF.loginController.set 'password', localStorage.getItem('password')
    SF.loginController.set 'id', localStorage.getItem('id')
    SF.loginController.tryLogin(true)
    SF.ip (response) -> SF.loginController.set 'ip', response

SF.IndexRoute = Ember.Route.extend
  redirect: ->
    if SF.loginController.get('username') isnt null then @transitionTo 'songs'

SF.LogoutRoute = Ember.Route.extend
  redirect: ->
    localStorage.clear()
    SF.loginController.set 'content', {}
    SF.loginController.set 'password', null
    SF.loginController.set 'username', null
    SF.loginController.set 'id', null
    @transitionTo 'index'

SF.SongsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    songs_model = []
    songs_model = SF.Song.findRecent()
    controller.set "songs", songs_model

SF.SongRoute = Ember.Route.extend
  model: (params) ->  
    SF.Song.find params.song_id
  setupController: (controller, model) ->
    controller.set "content", model

SF.MySongsRoute = Ember.Route.extend
  setupController: (controller, model) ->
    mysongs_model = []
    id = SF.loginController.get('id')
    if id then mysongs_model = SF.Song.findForUser(id) else @transitionTo 'songs'
    controller.set "songs", mysongs_model
