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