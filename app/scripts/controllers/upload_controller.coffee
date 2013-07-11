SF.UploadController = Ember.ObjectController.extend
  content: {}
  name: null
  artist: null
  description: null
  src: null
  genre: null
  agreeToTerms: false
  hasNotAgreed: Ember.computed.not('agreeToTerms')
  currentUploadedFile: null
  uploadComplete: (file) ->
    @set 'currentUploadedFile', file
  submit: ->
    dontSend = false
    if @get('currentUploadedFile') is null      
      $('.upload-file-group').addClass('error')
      alert "You must select an mp3 file to upload."
      dontSend = true
    if @name is null or @name.length is 0
      $('.song-name-group').addClass('error')
      dontSend = true
    if @artist is null or @artist.length is 0
      $('.artist-name-group').addClass('error')
      dontSend = true
    return if dontSend
    sfid = new Date().getTime()
    SF.Song.new
      song:
        sfid: sfid
        user: SF.loginController.get('content.id')
        name: @name
        artist: @artist
        description: @description 
        file: @currentUploadedFile.url
        size: @currentUploadedFile.size
        type: @currentUploadedFile.type
        genre: @genre
        date: new Date()
    if SF.loginController.content.songs is undefined then SF.loginController.content.set 'songs', [] 
    SF.loginController.content.songs.push sfid
    SF.User.update()
    _gaq.push(['_trackEvent', 'Songs', 'Upload', @name])
    @set 'name', null
    @set 'artist', null
    @set 'description', null
    @set 'src', null
    @set 'agreeToTerms', false
    @set 'genre', null
    @set 'currentUploadedFile', null 
    this.transitionToRoute 'songs'   