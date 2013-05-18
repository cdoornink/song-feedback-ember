SF.User = Ember.Object.extend
  setUserProperties: (properties) ->
    @set("id", properties.sfid);   
    @set("firstName", properties.first_name);
    @set("lastName", properties.last_name);
    @set("email", properties.email);
    @set("password", properties.password); 
    @set("memberSince", properties.member_since);   
    @set("songs", properties.songs);
    @set("comments", properties.comments);
    @set("reviews", properties.reviews);

SF.User.reopenClass
  find: (id) ->
    user = SF.User.create()
    SF.api "users/"+id, "GET", {}, (response) ->
      user.setUserProperties(response.user)
    user
  
  update: ->
    SF.api "users/"+SF.loginController.content.id, "PUT", SF.User.userToJSON(), (response) ->
      console.log response
    
  userToJSON:  ->
    user = 
      sfid: SF.loginController.content.id
      first_name: SF.loginController.content.firstName
      last_name: SF.loginController.content.lastName
      email: SF.loginController.content.email
      password: SF.loginController.content.password
      member_since: SF.loginController.content.memberSince
      songs: SF.loginController.content.songs
      comments: SF.loginController.content.comments
      reviews: SF.loginController.content.reviews
    