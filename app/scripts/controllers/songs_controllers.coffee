SF.MySongsController = Ember.ArrayController.extend
  songs: []

SF.SongsController = Ember.ArrayController.extend
  songs: []
  # leastRated: ->
#     #needs work, obviously

SF.ApplicationController = Ember.Controller.extend
  routeChanged: ( ->
    return unless window._gaq
    Em.run.next ->
      page = if window.location.hash.length > 0 then window.location.hash.substring(1) else window.location.pathname
      _gaq.push(['_trackPageview', page])
  ).observes('currentPath')

SF.SongController = Ember.ObjectController.extend
  inlineComment: null
  actions:
    comment: ->
      return if @inlineComment.length < 1
      me = SF.loginController.get('content.id')
      ip = SF.loginController.get('content.ip')
      if @inlineComment isnt null
        comment = 
          user: 
            id: me or ip
            fullName: if me then SF.loginController.content.firstName + " " + SF.loginController.content.lastName else "Anonymous User"
          message: @inlineComment
          date: new Date()
        comments = @get('content').get("comments")
        if comments is undefined or comments.length is 0
          @content.set "comments", [comment]
        else
          comments.addObject comment
        @set 'comment', null
        if me
          if SF.loginController.content.comments is undefined then SF.loginController.content.set 'comments', [] 
          SF.loginController.content.comments.push @content.id  
    
      SF.Song.update @content.id, SF.Song.songToJSON(@content)
      SF.User.update() if me
      @set 'inlineComment', null
      
      _gaq.push(['_trackEvent', 'Songs', 'inlineComment', @get('content.name')])