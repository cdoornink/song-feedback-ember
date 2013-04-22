var SF = Ember.Application.create();

//Router
SF.Router.map(function(){
  this.resource('login');
  this.resource("logout");
  this.resource('songs');
  this.resource('song', {path:'/songs/:song_id'});
  this.resource('my-songs', {path:'/my-songs'});
  this.resource('upload');
  this.resource('settings');
});

SF.ApplicationRoute = Ember.Route.extend({
  enter: function(){
    console.log('howdy')
    SF.loginController.set('username', localStorage.getItem('username'));
    SF.loginController.set('password', localStorage.getItem('password'));
    SF.loginController.set('id', localStorage.getItem('id'));
    SF.loginController.tryLogin(true);
  }
});

SF.LoginController = Ember.ObjectController.extend({
  isError: false,
  username: null,
  password: null,
  content: {},
  tryLogin: function(auto){
    console.log (auto ? "auto login" : "try login");
    that = this;
    SF.api("auth", "POST", {email:this.username,password:this.password}, function(response){
      if (response.user){
        var user = SF.User.create()
        user.setUserProperties(response.user);
        SF.loginController.set('content', user);
        localStorage.setItem('username', user.email);
        localStorage.setItem('password', user.password);
        localStorage.setItem('id', user.id);
        SF.loginController.set('isError', false);
        if(!auto)
          that.transitionToRoute('songs');
      }
      else if (!auto){
        SF.loginController.set('isError', true);
        SF.loginController.set('password', null);
      }
    });
  }
});
SF.loginController = SF.LoginController.create();

SF.LogoutRoute = Ember.Route.extend({
  redirect: function(){
    localStorage.clear();
    SF.loginController.set('content', {});
    SF.loginController.set('password', null);
    SF.loginController.set('username', null);
    SF.loginController.set('id', null);
    this.transitionTo('index');
  }
});

SF.ApplicationView = Ember.View.extend({  
  classNames: ['application-container']
});

SF.MySongsRoute = Ember.Route.extend({
  setupController: function(controller, model){
    console.log(SF.loginController.get('id'))
    controller.set("songs", []);
    var mysongs_model = ["fuck"]
    var id = SF.loginController.get('id')
    if(id){
      mysongs_model = SF.Song.findForUser(id);
    }
    else{
      this.transitionTo('songs')
    }
    console.log(controller);
    controller.set("songs", mysongs_model); 
  }
});

SF.MySongsController = Ember.ArrayController.extend({
  songs: []
});

//Browse
SF.SongsRoute = Ember.Route.extend({
  setupController: function(controller, model){
    controller.set("songs", []);
    var songs_model = []
    songs_model = SF.Song.findAll();
    controller.set("songs", songs_model);
  }
});

SF.SongRoute = Ember.Route.extend({
  model: function(params){    
    TheSong = SF.Song.find(params.song_id);
    return TheSong;
  },
  setupController: function(controller, model){
    controller.set("content", model);
  }
});

SF.SongsController = Ember.ArrayController.extend({
  songs: [],
  recent: function(){},
  leastRated: function(){
    var newSong = {song:{
      sfid: "10",
      user: "1",
      name: "I'm making progress",
      artist: "Rejuvinilezzz",
      file: null,
      description: "I am free of ember data shackles...",
      genre: "Poop Pop",
      reviews: [{
        overall: 8,
        vocals: 6,
        songwriting: 5,
        musicianship: 4,
        creativity: 6,
        production: 5,
        date: new Date()        
      }],
      date: new Date()}
    }
    // var newReview = SF.Review.createRecord({
//       overall: 8,
//       vocals: 6,
//       songwriting: 5,
//       musicianship: 4,
//       creativity: 6,
//       production: 5,
//       date: new Date()
//     });
    console.log(newSong);
    SF.Song.new(newSong);
  }
});

//Song Page
SF.PieView = Ember.View.extend({
  didInsertElement: function(){
    this.renderGraph();
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

//DATA MODELS
SF.api = function(req, type, data, callback){
  // var url = "http://localhost:5000/";
  var url = "http://nameless-beyond-8616.herokuapp.com/";
  console.log("make "+type+" request for "+req);
  $.ajax({
    url: url+req,
    dataType: 'json',
    type: type,
    data: data,
    success: function(response){if(callback){callback(response)}}
  });
}

SF.User = Ember.Object.extend({
  setUserProperties: function(properties){
    this.set("id", properties.sfid);   
    this.set("firstName", properties.first_name);
    this.set("lastName", properties.last_name);
    this.set("email", properties.email);
    this.set("password", properties.password); 
    this.set("memberSince", properties.memberSince);   
    this.set("songs", properties.songs);
    this.set("comments", properties.comments);
    this.set("reviews", properties.reviews);
  }
});
SF.User.reopenClass({
  find: function(id){
    var user = SF.User.create()
    SF.api("users/"+id, "GET", {}, function(response){
      user.setUserProperties(response.user);
    });
    return user;
  },
  authenticate: function(u,p,callback){
    
    return user;
  }
});

SF.Song = Ember.Object.extend({
  comments: [],
  reviews: [],
  reviewCount: function(){
    if(this.get('reviews') != undefined)
      return this.get('reviews').length
    return 0
  }.property('reviews.@each.overall'),
  commentCount: function(){
    if(this.get('comments') != undefined)
      return this.get('comments').length
    return 0
  }.property('comments.@each.message'),
  overall: function(){
    if(this.get('reviews') != undefined){
      if(this.get('reviews').length == 0){return "na"}
      var sum = this.get('reviews').getEach('overall').reduce(function(a,i){return a+i}, 0);
      return sum/(this.get('reviews').getEach('overall').length);
    }
    return "na"
  }.property('reviews.@each.overall'),
  vocals: function(){
    if(this.get('reviews') != undefined){
      if(this.get('reviews').length == 0){return "na"}
      var sum = this.get('reviews').getEach('vocals').reduce(function(a,i){return a+i}, 0);
      return sum/(this.get('reviews').getEach('vocals').length);
    }
    return "na"
  }.property('reviews.@each.vocals'),
  songwriting: function(){
    if(this.get('reviews') != undefined){
      if(this.get('reviews').length == 0){return "na"}
      var sum = this.get('reviews').getEach('songwriting').reduce(function(a,i){return a+i}, 0);
      return sum/(this.get('reviews').getEach('songwriting').length);
    }
    return "na"
  }.property('reviews.@each.songwriting'),
  musicianship: function(){
    if(this.get('reviews') != undefined){
      if(this.get('reviews').length == 0){return "na"}
      var sum = this.get('reviews').getEach('musicianship').reduce(function(a,i){return a+i}, 0);
      return sum/(this.get('reviews').getEach('musicianship').length);
    }
    return "na"
  }.property('reviews.@each.musicianship'),
  creativity: function(){
    if(this.get('reviews') != undefined){
      if(this.get('reviews').length == 0){return "na"}
      var sum = this.get('reviews').getEach('creativity').reduce(function(a,i){return a+i}, 0);
      return sum/(this.get('reviews').getEach('creativity').length);
    }
    return "na"
  }.property('reviews.@each.creativity'),
  production: function(){
    if(this.get('reviews') != undefined){
      if(this.get('reviews').length == 0){return "na"}
      var sum = this.get('reviews').getEach('production').reduce(function(a,i){return a+i}, 0);
      return sum/(this.get('reviews').getEach('production').length);
    }
    return "na"
  }.property('reviews.@each.production'),
  graphData: function(){
    var data = [
      ['Vocals', this.get('vocals')],['Songwriting', this.get('songwriting')], ['Musicianship', this.get('musicianship')], 
      ['Creativity', this.get('creativity')],['Production', this.get('production')]
    ];
    return data;
  }.property('production'),
  setSongProperties: function(properties){
    this.set("id", properties.sfid)
    this.set("name", properties.name)
    this.set("artist", properties.artist)
    this.set("user", properties.user)
    this.set("file", properties.file)
    this.set("description", properties.description)
    this.set("genre", properties.genre)
    this.set("reviews", properties.reviews)
    this.set("comments", properties.comments)
    this.set("date", new Date(properties.date))
  }
});
SF.Song.reopenClass({
  find: function(id){
    var song = SF.Song.create();
    SF.api("songs/"+id, "GET", {}, function(response){
      song.setSongProperties(response.song[0]);
    });
    return song;
  },
  findAll: function(){
    var songs = [];
    SF.api("songs", "GET", {}, function(response){
      response.songs.forEach(function(s){
        var song = SF.Song.create();
        song.setSongProperties(s);
        songs.addObject(song);
      });
    });
    return songs;
  },
  findForUser: function(id){
    var songs = [];
    SF.api("songs/user/"+id, "GET", {}, function(response){
      response.songs.forEach(function(s){
        var song = SF.Song.create();
        song.setSongProperties(s);
        songs.addObject(song);
      });
    });
    return songs;
  },
  new: function(data){
    SF.api("songs", "POST", data, function(response){
      console.log("response")
    });
  }
  
});