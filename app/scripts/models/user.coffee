SF.User = Ember.Object.extend
  setUserProperties: (properties) ->
    @set("id", properties.sfid);   
    @set("firstName", properties.first_name);
    @set("lastName", properties.last_name);
    @set("email", properties.email);
    @set("password", properties.password); 
    @set("memberSince", properties.memberSince);   
    @set("songs", properties.songs);
    @set("comments", properties.comments);
    @set("reviews", properties.reviews);

SF.User.reopenClass
  find: (id) ->
    user = SF.User.create()
    SF.api "users/"+id, "GET", {}, (response) ->
      user.setUserProperties(response.user)
    user
