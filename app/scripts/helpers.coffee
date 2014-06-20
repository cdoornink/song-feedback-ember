Ember.Handlebars.registerBoundHelper "fromnow", (date) ->
  unless date is undefined then return moment(date).fromNow()
  
Ember.Handlebars.registerBoundHelper "mdy", (date) ->
  unless date is undefined then return moment(date).format('MMMM Do YYYY')

Ember.Handlebars.registerBoundHelper "bargraph", (n) ->
    new Handlebars.SafeString('<div class="bar" style="height: '+n*10+'%"></div>')

Ember.Handlebars.registerBoundHelper "minibar", (n) ->
    new Handlebars.SafeString('<div class="score"><div class="minibar" style="height: '+n*10+'%"></div></div>')
      
Ember.Handlebars.registerBoundHelper "rounded", (n) ->
  Math.round( n * 10 ) / 10;
      
Ember.TextField.reopen
  attributeBindings: ["required"]