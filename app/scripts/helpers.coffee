Ember.Handlebars.registerBoundHelper "fromnow", (date) ->
  unless date is undefined then return moment(date).fromNow()
  
Ember.Handlebars.registerBoundHelper "mdy", (date) ->
  unless date is undefined then return moment(date).format('MMMM Do YYYY')

Ember.Handlebars.registerBoundHelper "bargraph", (n) ->
    new Handlebars.SafeString('<div class="bar" style="width: '+n*8+'%"></div>')
      
Ember.TextField.reopen
  attributeBindings: ["required"]