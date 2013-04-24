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
    if @get('reviews') isnt undefined
      if @get('reviews').length is 0 then return "na"
      sum = @get('reviews').getEach('overall').reduce ((a,i) -> 
        a+i
      ), 0
      sum / (@get('reviews').getEach('overall').length)
    else
      "na"
  ).property('reviews.@each.overall')
  
  vocals: (->
    if @get('reviews') isnt undefined
      if @get('reviews').length is 0 then return "na"
      sum = this.get('reviews').getEach('vocals').reduce ((a,i) -> 
        a+i
      ), 0
      sum / (@get('reviews').getEach('vocals').length)
    else
      "na"
  ).property('reviews.@each.vocals')
  
  songwriting: (->
    if @get('reviews') isnt undefined
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("songwriting").reduce ((a, i) ->
        a + i
      ), 0
      sum / @get('reviews').getEach('songwriting').length
    else
      "na"
  ).property('reviews.@each.songwriting')
  
  musicianship: (->
    if @get('reviews') isnt undefined
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("musicianship").reduce ((a, i) ->
        a + i
      ), 0
      sum / @get('reviews').getEach('musicianship').length
    else
      "na"
  ).property('reviews.@each.musicianship')
  
  creativity: (->
    if @get('reviews') isnt undefined
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("creativity").reduce ((a, i) ->
        a + i
      ), 0
      sum / @get('reviews').getEach('creativity').length
    else
      "na"
  ).property('reviews.@each.creativity')
  
  production: (->
    if @get('reviews') isnt undefined
      if @get('reviews').length is 0 then return "na"
      sum = @get("reviews").getEach("production").reduce ((a, i) ->
        a + i
      ), 0
      sum / @get('reviews').getEach('production').length
    else
      "na"
  ).property('reviews.@each.production')
  
  graphData: (->
    [['Vocals', @get('vocals')],['Songwriting', @get('songwriting')],['Musicianship', @get('musicianship')],['Creativity', @get('creativity')],['Production', @get('production')]]
  ).property('production')
  
  setSongProperties: (properties) ->
    @set("id", properties.sfid)
    @set("name", properties.name)
    @set("artist", properties.artist)
    @set("user", properties.user)
    @set("file", properties.file)
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
    
  findForUser: (id) ->
    songs = []
    SF.api "songs/user/"+id, "GET", {}, (response) ->
      response.songs.forEach (s) ->
        songs.addObject SF.Song.create().setSongProperties(s)
    songs
    
  new: (data) ->
    SF.api "songs", "POST", data, (response) ->
      console.log "response"
