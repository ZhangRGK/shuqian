Template.main.helpers({
  isExplore:->
    window.location.pathname == "/explore"
  isCommon:->
    window.location.pathname == "/common"
  isHelp:->
    window.location.pathname == "/help"
  userInfo:->
    user = Meteor.user()
    console.log(user)
    if user
      if user.emails[0]
        console.log(user.emails[0])
        return {"name":user.emails[0].address,"url":"http://www.gravatar.com/avatar/"+MD5(user.emails[0].address)}
    else
      return false
})
Template.main.events = {
  'click #savetagbtn':(evt, template)->
    $('#myModal').modal('hide')
    tag = $('#tagname').val()
    $('#tagname').val('')
    $('input[name="bookmark"]:checked').map(->
      bookMarkUrl = $(this).val()
      bookMark = getBookmarkByUrl(bookMarkUrl)
      addTag(bookMark, tag)
    )
  'keypress #tagname':(evt, template)->
    if evt.keyCode==13
      $('#myModal').modal('hide')
      #禁止界面刷新
      evt.preventDefault()
      tag = $('#tagname').val()
      $('#tagname').val('')
      $('input[name="bookmark"]:checked').map(->
        bookMarkUrl = $(this).val()
        bookMark = getBookmarkByUrl(bookMarkUrl)
        addTag(bookMark, tag)
      )
  'click #signOut':->
    Meteor.logout((error)->
      if error
        console.log error
      else
        Router.go("/login")
    )
  'click #toResponsive':->
    $("#container").removeClass('container')
    $(".fixedItem").removeClass('container').addClass('container-fluid')
    $("#left-side").removeClass('left_boxed')
  'click #toBoxed':->
    $("#container").addClass('container')
    $(".fixedItem").removeClass('container-fluid').addClass('container')
    $("#left-side").addClass('left_boxed')
}

Template.main.rendered = ->
  user = Meteor.user()
  if user
    if !user.emails
      Meteor.call("getUserInfo",(error, userInfo)->
        name = userInfo.services.google.name
        console.log name
        $("#user-avatar").attr("src",userInfo.services.google.picture)
        $("#user-email").html(name)
      )


#
#displayUserinfo = ->
#  user = Meteor.user()
#  if user
#    if user.emails
#      email = Meteor.user().emails[0].address
#      url = "http://www.gravatar.com/avatar/"+MD5(email)
#      $("#user-avatar").attr("src",url)
#      $("#user-email").html(email)
#    else
#      Meteor.call("getUserInfo",(error, userInfo)->
#        name = userInfo.services.google.name
#        $("#user-avatar").attr("src",userInfo.services.google.picture)
#        $("#user-email").html(name)
#      )
#  else
#    setTimeout(displayUserinfo,3000)

Meteor.startup(->
  Deps.autorun(->
    user = Meteor.user()
    if user
      if user.emails
        email = user.emails[0].address
        localStorage.setItem("userEmail", email)
        localStorage.setItem("userType", 0)
      else
        Meteor.call("getUserInfo",(error, userInfo)->
          email = userInfo.services.google.email
          localStorage.setItem("userEmail", email)
          localStorage.setItem("userType", 1)
        )
  )
)
