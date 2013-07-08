SF.PlayerController = Ember.ObjectController.extend
  content: null
  vocals: 5
  songwriting: 5
  musicianship: 5
  production: 5
  creativity: 5
  overall: 5
  comment: null
  confirmFeedback: false
  flashConfirmation: (->
    if @get 'confirmFeedback'
      $('.confirm-feedback').fadeIn()
      @set 'queryTimeout', setTimeout ( ->
        $(".confirm-feedback").fadeOut()
      ), 4000
    @set 'confirmFeedback', false
  ).observes('confirmFeedback')
  playSong: (song) ->
    @set('content', song)
    $("#jquery_jplayer_1").jPlayer "setMedia", mp3: song.file
    $("#jquery_jplayer_1").jPlayer "play"
    @expandPlayer()
  expandPlayer: ->
    $(".player").addClass("expanded")
  compressPlayer: ->
    $(".player").removeClass("expanded")
  togglePlayerView: ->
    if $(".player").css("height") is "300px" then @compressPlayer() else @expandPlayer()
  submitFeedback: ->
    me = SF.loginController.get('content.id')
    ip = SF.loginController.get('content.ip')
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
      user: me or ip
      date: new Date()

    if reviews is undefined or reviews.length is 0
      @content.set "reviews", [review]
    else
      reviews.getEach('user').forEach (u,i) -> 
        if (me and u is me) or (!me and u is ip)
          reviews.splice(i,1)
          rereviewed = true  
      reviews.addObject review
    
    if @comment isnt null
      comment = 
        user: 
          id: me or ip
          fullName: if me then SF.loginController.content.firstName + " " + SF.loginController.content.lastName else "Anonymous User"
        message: @comment
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
      
    if me and !rereviewed
      if SF.loginController.content.reviews is undefined then SF.loginController.content.set 'reviews', [] 
      SF.loginController.content.reviews.push @content.id
    
    SF.Song.update @content.id, SF.Song.songToJSON(@content)
    SF.User.update() if me
    @set 'confirmFeedback', true
  
    
SF.playerController = SF.PlayerController.create()
