var SF = Ember.Application.create();

//Router
SF.Router.map(function(){
  this.route('browse');
  this.resource('songs');
  this.resource('song', {path:'/songs/:song_id'});
  this.resource('user', {path:'/users/:user_id'});
});

SF.ApplicationRoute = Ember.Route.extend({
  model: function(){
    return SF.User.find("5164f3d489cc210000000006")
  }
});

SF.UserRoute = Ember.Route.extend({
  redirect: function(){
    var userId = this.controllerFor('application').get('model').get('id')
    var pageUserId = this.get('currentModel').get('id')
    if(userId != pageUserId){
      this.transitionTo("browse");
    }
  }
});

//Browse
SF.BrowseRoute = Ember.Route.extend({
  redirect: function(){
    this.transitionTo('songs');
  }
});

SF.SongsRoute = Ember.Route.extend({
  setupController: function(controller, model){
    browse_model = SF.Song.find();
    controller.set("content", browse_model)
  }
});

SF.SongsController = Ember.ArrayController.extend({
  recent: function(){
    var content = this.get('content').get('content');
    var sorted = content.sort(function(a,b) { return b.id - a.id; });    
    var newOrder = []
    console.log(sorted);
    sorted.each(function(a){
      newOrder.push(a);
    });
    console.log(newOrder);
    this.get('content').set('content', newOrder);
  },
  leastRated: function(){
    var content = this.get('content').get('content')
    console.log(content)
  }
});

//Song Page
SF.SongView = Ember.View.extend({  
  didInsertElement: function() {
    this.renderGraph()
  },
  renderGraph: function() {
    if($('#balance-pie').is(":visible")){
      var plot1 = jQuery.jqplot ('balance-pie', [this.get('controller').get('graphData')],{ 
        seriesDefaults: {
          renderer: jQuery.jqplot.PieRenderer, 
          rendererOptions: {
            sliceMargin: 5,
            showDataLabels: true,
            dataLabels: 'label'
          }
        },
        title: "Balance", 
        seriesColors: [ "#B2CCD4", "#72C7D4", "#65A8BA", "#7E9396", "#498087"],
        legend: { show:false, location: 'e' },
        grid: {borderWidth:0, shadow:false}}
      );
    }
  }.observes('this.controller.graphData')  
});

//Helpers
Ember.Handlebars.registerBoundHelper("mdy", function(date){
  if(date != undefined){
    var d= date.getDate();var m = date.getMonth()+1;var y = date.getFullYear(); //Months are zero based
    switch(m){case 1:s="Jan";break;case 2:s="Feb";break;case 3:s="Mar";break;case 4:s="Apr";break;case 5:s="May";break;case 6:s="Jun";break;case 7:s="Jul";break;case 8:s="Aug";break;case 9:s="Sep";break;case 10:s="Oct";break;case 11:s="Nov";break;case 12:s="Dec";break;}
    return (s + " " + d + ", " + y);
  }
});

Ember.Handlebars.registerBoundHelper("bargraph", function(n){
    return new Handlebars.SafeString('<div class="bar" style="width: '+n*8+'%"></div>');
});

// Models
SF.Store = DS.Store.extend({
  revision: 11,
  adapter: 'DS.RESTAdapter'
});

DS.RESTAdapter.reopen({
  url: 'http://localhost:8080'
});

SF.User = DS.Model.extend({
  firstName: DS.attr("string"),
  lastName: DS.attr("string"),
  email: DS.attr("string"),
  password: DS.attr("string"),
  songs: DS.hasMany("SF.Song"),
  memberSince: DS.attr('date'),
  comments: DS.hasMany('SF.Comment'),
  reviews: DS.hasMany('SF.Review'),
  fullName: function() {
    return this.get('firstName') + ' ' + this.get('lastName');
  }.property('firstName', 'lastName')
});

SF.Song = DS.Model.extend({
  name: DS.attr('string'),
  artist: DS.attr('string'),
  user: DS.belongsTo('SF.User'),
  file: DS.attr('string'),
  description: DS.attr('string'),
  genre: DS.belongsTo('SF.Genre'),
  reviews: DS.hasMany('SF.Review'),
  comments: DS.hasMany('SF.Comment'),
  date: DS.attr('date'),
  reviewCount: function(){
    return this.get('reviews').getEach('overall').length
  }.property('reviews.@each.overall'),
  commentCount: function(){
    return this.get('comments').getEach('message').length
  }.property('comments.@each.message'),
  overall: function(){
    sum = this.get('reviews').getEach('overall').reduce(function(a,i){return a+i}, 0);
    return sum/(this.get('reviews').getEach('overall').length);
  }.property('reviews.@each.overall'),
  vocals: function(){
    sum = this.get('reviews').getEach('vocals').reduce(function(a,i){return a+i}, 0);
    return sum/(this.get('reviews').getEach('vocals').length);
  }.property('reviews.@each.vocals'),
  songwriting: function(){
    sum = this.get('reviews').getEach('songwriting').reduce(function(a,i){return a+i}, 0);
    return sum/(this.get('reviews').getEach('songwriting').length);
  }.property('reviews.@each.songwriting'),
  musicianship: function(){
    sum = this.get('reviews').getEach('musicianship').reduce(function(a,i){return a+i}, 0);
    return sum/(this.get('reviews').getEach('musicianship').length);
  }.property('reviews.@each.musicianship'),
  creativity: function(){
    sum = this.get('reviews').getEach('creativity').reduce(function(a,i){return a+i}, 0);
    return sum/(this.get('reviews').getEach('creativity').length);
  }.property('reviews.@each.creativity'),
  production: function(){
    sum = this.get('reviews').getEach('production').reduce(function(a,i){return a+i}, 0);
    return sum/(this.get('reviews').getEach('production').length);
  }.property('reviews.@each.production'),
  graphData: function(){
    var data = [
      ['Vocals', this.get('vocals')],['Songwriting', this.get('songwriting')], ['Musicianship', this.get('musicianship')], 
      ['Creativity', this.get('creativity')],['Production', this.get('production')]
    ];
    return data;
  }.property('production')
});

SF.Review = DS.Model.extend({
  song: DS.belongsTo("SF.Song"),
  overall: DS.attr('number'),
  vocals: DS.attr('number'),
  songwriting: DS.attr('number'),
  musicianship: DS.attr('number'),
  creativity: DS.attr('number'),
  production: DS.attr('number'),
  user: DS.belongsTo('SF.User'),
  date: DS.attr('date')
});

SF.Comment = DS.Model.extend({
  song: DS.belongsTo("SF.Song"),
  message: DS.attr('string'),
  user: DS.belongsTo('SF.User'),
  date: DS.attr('date')
});

SF.Genre = DS.Model.extend({
  name: DS.attr('string')
});