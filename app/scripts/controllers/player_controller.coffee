SF.PlayerController = Ember.ObjectController.extend
  content: null
  vocals: 5
  songwriting: 5
  musicianship: 5
  production: 5
  creativity: 5
  overall: 5
  comment: null
  playSong: (song) ->
    audio = new Audio()
    @set('content', song)
    audio.src = song.file
    @expandPlayer()
    console.log audio
    console.log audio[0]
    audio.play()
    audio.addEventListener "error", (failed = (e) ->
      switch e.target.error.code
        when e.target.error.MEDIA_ERR_ABORTED
          alert "You aborted the video playback."
        when e.target.error.MEDIA_ERR_NETWORK
          alert "A network error caused the audio download to fail."
        when e.target.error.MEDIA_ERR_DECODE
          alert "The audio playback was aborted due to a corruption problem or because the video used features your browser did not support."
        when e.target.error.MEDIA_ERR_SRC_NOT_SUPPORTED
          alert "The video audio not be loaded, either because the server or network failed or because the format is not supported."
        else
          alert "An unknown error occurred."
    ), true
  expandPlayer: ->
    $(".player").addClass("expanded")
  compressPlayer: ->
    $(".player").removeClass("expanded")
  togglePlayerView: ->
    if $(".player").css("height") is "300px" then @compressPlayer() else @expandPlayer()
  submitFeedback: ->
    return if @get('content') is null
    reviews = @get('content').get("reviews")
    rereviewed = false
    review = 
      overall: @overall
      vocals: @vocals
      songwriting: @songwriting
      musicianship: @musicianship
      creativity: @creativity
      production: @production
      user: SF.loginController.get('content.id')
      date: new Date()
    
    if reviews is undefined or reviews.length is 0
      @content.set "reviews", [review]
    else
      reviews.getEach('user').forEach (u,i) -> 
        if u is SF.loginController.get('content.id')
          reviews.splice(i)
          rereviewed = true
      reviews.addObject review
    
    if @comment isnt null
      comment = 
        user: 
          id: SF.loginController.get('content.id')
          fullName: SF.loginController.content.firstName + " " + SF.loginController.content.lastName
        message: @comment
        date: new Date()
      comments = @get('content').get("comments")
      if comments is undefined or comments.length is 0
        @content.set "comments", [comment]
      else
        comments.addObject comment
      @set 'comment', null
      if SF.loginController.content.comments is undefined then SF.loginController.content.set 'comments', [] 
      SF.loginController.content.comments.push @content.id  
      
    unless rereviewed
      if SF.loginController.content.reviews is undefined then SF.loginController.content.set 'reviews', [] 
      SF.loginController.content.reviews.push @content.id
    
    SF.Song.update @content.id, SF.Song.songToJSON(@content)
    SF.User.update()
    
SF.playerController = SF.PlayerController.create()
