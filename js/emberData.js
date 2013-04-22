Models
DS.RESTAdapter.map('SF.Song', {
  primaryKey: '_id'
});

SF.Store = DS.Store.extend({
  revision: 11,
  adapter: DS.RESTAdapter.create({
    url: 'http://localhost:5000'
  })
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
  sfid: DS.attr('string'),
  name: DS.attr('string'),
  artist: DS.attr('string'),
  user: DS.belongsTo('SF.User'),
  file: DS.attr('string'),
  description: DS.attr('string'),
  genre: DS.attr('string'),
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
  song: DS.belongsTo('SF.Song'),
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
  song: DS.belongsTo('SF.Song'),
  message: DS.attr('string'),
  user: DS.belongsTo('SF.User'),
  date: DS.attr('date')
});