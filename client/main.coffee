Template.main.helpers({
  isExplore:->
    window.location.pathname == "/explore"
  isCommon:->
    window.location.pathname == "/common"
  isHelp:->
    window.location.pathname == "/help"
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
  console.log 'rendered'
  console.log localStorage.getItem("userType")
  console.log localStorage.getItem("userEmail")
  console.log Meteor.user()

  if localStorage.getItem("userType") == 1
    Meteor.call("getUserInfo",(error, userInfo)->
      console.log 'rendered call'
      console.log Meteor.user()
      console.log userInfo
      console.log $("#user-avatar")
      console.log $("#user-email")
      name = userInfo.services.google.name
      $("#user-avatar").attr("src",userInfo.services.google.picture)
      $("#user-email").html(name)
    )
  else
    console.log 'rendered local'
    console.log $("#user-avatar")
    console.log $("#user-email")
    email = localStorage.getItem("userEmail")
    url = "http://www.gravatar.com/avatar/"+MD5(email)
    $("#user-avatar").attr("src",url)
    $("#user-email").html(email)


Meteor.startup(->
  Deps.autorun(->
    console.log 'autorun'
    console.log localStorage.getItem("userType")
    console.log localStorage.getItem("userEmail")
    console.log Meteor.user()
    user = Meteor.user()
    if user
      if user.emails
        console.log 'rendered local'
        console.log $("#user-avatar")
        console.log $("#user-email")
        email = user.emails[0].address
        localStorage.setItem("userEmail", email)
        localStorage.setItem("userType", 0)
      else
        Meteor.call("getUserInfo",(error, userInfo)->
          console.log 'autorun call'
          console.log Meteor.user()
          console.log userInfo
          console.log $("#user-avatar")
          console.log $("#user-email")
          email = userInfo.services.google.email
          localStorage.setItem("userEmail", email)
          localStorage.setItem("userType", 1)
        )
  )
)
