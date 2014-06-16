SF.genres = ["Rock", "Rap/Hip-Hop", "Pop", "Country", "Indie", "Singer/Songwriter", "Folk", "Electronica", "Other"];

SF.Song = Ember.Object.extend
  comments: []
  
  reviews: []
  
  reviewCount: (->
    if @get('reviews') isnt undefined then @get('reviews').length else 0
  ).property('reviews.@each.overall')
  
  commentCount: (->
    if @get('comments') isnt undefined then @get('comments').length else 0
  ).property('comments.@each.message')
  
  overall: (->
    if @get('reviews') is undefined then return "na" else
      if @get('reviews').length is 0 or @get('reviews').length is undefined then return "na"
      sum = @get('reviews').getEach('overall').reduce (a,i) -> parseInt(a) + parseInt(i)
      sum / (@get('reviews').getEach('overall').length)
  ).property('reviews.@each.overall')
  
  vocals: (->
    if @get('reviews') is undefined then return "na" else
      if @get('reviews').length is 0 then return "na"
      sum = this.get('reviews').getEach('vocals').reduce (a,i) -> parseInt(a) + parseInt(i)
      sum / (@get('reviews').getEach('vocals').length)
  ).property('reviews.@each.vocals')
  
  songwriting: (->
    if @get('reviews') is undefined then return "na" else
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("songwriting").reduce (a, i) -> parseInt(a) + parseInt(i)
      sum / @get('reviews').getEach('songwriting').length
  ).property('reviews.@each.songwriting')
  
  musicianship: (->
    if @get('reviews') is undefined then return "na" else
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("musicianship").reduce (a, i) -> parseInt(a) + parseInt(i)
      sum / @get('reviews').getEach('musicianship').length
  ).property('reviews.@each.musicianship')
  
  creativity: (->
    if @get('reviews') is undefined then return "na" else
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("creativity").reduce (a, i) -> parseInt(a) + parseInt(i)
      sum / @get('reviews').getEach('creativity').length
  ).property('reviews.@each.creativity')
  
  production: (->
    if @get('reviews') is undefined then return "na" else
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("production").reduce (a, i) -> parseInt(a) + parseInt(i)
      sum / @get('reviews').getEach('production').length
  ).property('reviews.@each.production')
  
  graphData: (->
    [['Vocals', @get('vocals')],['Songwriting', @get('songwriting')],['Musicianship', @get('musicianship')],['Creativity', @get('creativity')],['Production', @get('production')]]
  ).property('production')
  
  isMine: (->
    SF.loginController.get('id') == @get('user')
  ).property('user')
  
  setSongProperties: (properties) ->
    @set("id", properties.sfid)
    @set("bson", properties._id)
    @set("name", properties.name)
    @set("artist", properties.artist)
    @set("user", properties.user)
    @set("file", properties.file)
    @set("size", properties.size)
    @set("type", properties.type)
    @set("description", properties.description)
    @set("genre", properties.genre)
    @set("reviews", properties.reviews)
    @set("comments", properties.comments)
    @set("date", new Date(properties.date))

SF.Song.reopenClass
  find: (id) ->
    song = SF.Song.create()
    SF.api "songs/"+id, "GET", {}, (response) ->
      song.setSongProperties response.song[0]
    song
  
  findAll: ->
    songs = []
    SF.api "songs", "GET", {}, (response) ->
      response.songs.forEach (s) ->
        songs.addObject SF.Song.create().setSongProperties(s)
    songs
  
  findRecent: ->
    songs = []
    SF.api "songs/recent/all", "GET", {}, (response) ->
      response.songs.forEach (s) ->
        songs.addObject SF.Song.create().setSongProperties(s)
    songs
    
  findForUser: (id) ->
    songs = []
    SF.api "songs/user/"+id, "GET", {}, (response) ->
      response.songs.forEach (s) ->
        songs.addObject SF.Song.create().setSongProperties(s)
    songs
    
  new: (data) ->
    SF.api "songs", "POST", data
  
  update: (id, data) ->
    SF.api "songs/"+id, "PUT", data
    
  songToJSON: (data) ->
    song = 
      sfid: data.id
      user: data.user
      name: data.name
      artist: data.artist
      description: data.description 
      file: data.file
      size: data.size
      type: data.type
      genre: data.genre
      date: data.date
      comments: data.comments
      reviews: data.reviews