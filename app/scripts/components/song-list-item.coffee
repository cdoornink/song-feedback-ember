SF.SongListItemComponent = Ember.Component.extend
  actions:
    play: ->
      SF.playerController.playSong @get('song')
