Ember.Handlebars.registerBoundHelper "mdy", (date) ->
  unless date is undefined
    d = date.getDate()
    m = date.getMonth()+1
    y = date.getFullYear()
    s = switch m
      when 1 then "Jan"
      when 2 then "Feb"
      when 3 then "Mar"
      when 4 then "Apr"
      when 5 then "May"
      when 6 then "Jun"
      when 7 then "Jul"
      when 8 then "Aug"
      when 9 then "Sep"
      when 10 then "Oct"
      when 11 then "Nov"
      when 12 then "Dec"
    return (s + " " + d + ", " + y)

Ember.Handlebars.registerBoundHelper "bargraph", (n) ->
    new Handlebars.SafeString('<div class="bar" style="width: '+n*8+'%"></div>')
      