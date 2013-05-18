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
    sfid = new Date().getTime()
    SF.Song.new
      song:
        sfid: sfid
        user: SF.loginController.get('content.id')
        name: @name
        artist: @artist
        description: @description 
        file: "figureOutLater"
        genre: @genre
        date: new Date()
    if SF.loginController.content.songs is undefined then SF.loginController.content.set 'songs', [] 
    SF.loginController.content.songs.push sfid
    SF.User.update()