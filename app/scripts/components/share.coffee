SF.ShareContainerComponent = Ember.Component.extend
  classNames: ['share-container']

SF.ShareTwitterComponent = Ember.Component.extend
  classNames: ['share-icon', 'twitter-icon']
  click: ->
    mine = @get('item.isMine')
    if mine
      text = encodeURIComponent('Check out my song, "'+@get("item.name")+'". I need honest feedback!')
    else
      text = encodeURIComponent('Check out "'+@get("item.name")+'" on Song Feedback.')
    url = encodeURIComponent("http://songfeedback.com/#/songs/#{@get('item.id')}")
    sharerUrl = "http://twitter.com/share?url=" + url + "&text=" + text
    window.open(sharerUrl, "_sharePopup", "width=550,height=258")

SF.ShareFacebookComponent = Ember.Component.extend
  classNames: ['share-icon', 'facebook-icon']
  click: ->
    url = encodeURIComponent("http://songfeedback.com/#/songs/#{@get('item.id')}")
    sharerUrl = "http://www.facebook.com/sharer.php?u=" + url
    window.open(sharerUrl, "_sharePopup", "width=630,height=430")

SF.ShareGoogleComponent = Ember.Component.extend
  classNames: ['share-icon', 'google-icon']
  click: ->
    url = encodeURIComponent("http://songfeedback.com/#/songs/#{@get('item.id')}")
    sharerUrl = "https://plus.google.com/share?url=" + url
    window.open(sharerUrl, "_sharePopup", "width=550,height=450")
