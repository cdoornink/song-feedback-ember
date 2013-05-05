SF.ApplicationView = Ember.View.extend
  classNames: ['application-container']

SF.PlayerView = Ember.View.extend
  classNames: ['player']
  templateName: "player"

SF.SongListItemView = Ember.View.extend
  templateName: 'song-list-item'
  click: ->
    SF.playerController.playSong @get('content')

SF.PieView = Ember.View.extend
  didInsertElement: ->
    @renderGraph()
  renderGraph: (->
    if $('#balance-pie').is(":visible")
      plot1 = jQuery.jqplot 'balance-pie', [@get('controller').get('graphData')],  
        seriesDefaults: 
          renderer: jQuery.jqplot.PieRenderer
          rendererOptions: 
            sliceMargin: 5
            showDataLabels: true
            dataLabels: 'label'
        title: "Balance"
        seriesColors: [ "#B2CCD4", "#72C7D4", "#65A8BA", "#7E9396", "#498087"]
        legend: { show:false, location: 'e' }
        grid: {borderWidth:0, shadow:false}
  ).observes('this.controller.graphData')  
  
SF.RatingSliderView = Ember.View.extend
  classNames: ['rating-container']
  mouseMove: (e) ->
    
    elOffset = this.$().offset()  
    relX = e.pageX - elOffset.left
    console.log "180 - ("+e.pageX+" - "+elOffset.left+") = "+relX
    val = Math.round(relX / 18) * 18;
    this.$(".hoverer").css('width', val)
  mouseLeave: ->
    this.$(".hoverer").css('width', 0)
  click: (e) ->
    elOffset = this.$().offset()  
    relX = e.pageX - elOffset.left
    val = Math.round(relX / 18) * 18;
    this.$(".rating").css('width', val)
    
SF.PlayerGrippyView = Ember.View.extend
  classNames: ['player-grippy']
  click: ->
    SF.playerController.togglePlayerView()

SF.UploadView = Ember.View.extend
  didInsertElement: ->
    console.log "gettin ready to upload!"
    unless window.File and window.FileReader and window.FileList and window.Blob
      alert('The File APIs are not fully supported in this browser.')

SF.uploadSrc = Ember.Object.create
  src: ''
  
SF.fileField = Ember.TextField.extend
  type: 'file'
  attributeBindings: ['file']
  change: (evt) ->
    input = evt.target
    if input.files and input.files[0]
      if input.files[0].type == "audio/mp3" or input.files[0].type == "audio/x-m4a "
        reader = new FileReader()
        that = this
        reader.onload = (e) ->
          that.get('controller').set('src', e.target.result);
        reader.readAsDataURL(input.files[0]);
      else
        alert("invalid file type")
