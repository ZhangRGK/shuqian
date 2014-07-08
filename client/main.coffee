Template.main.events = {
  'click #savetagbtn':(evt, template)->
    $('#myModal').modal('hide')
    tag = $('#tagname').val()
    $('#tagname').val('')
    $('input[name="bookmark"]:checked').map(->
      bookMarkId = $(this).val()
      bookMark = getBookmarkById(bookMarkId)
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
        bookMarkId = $(this).val()
        bookMark = getBookmarkById(bookMarkId)
        addTag(bookMark, tag)
      )
  'click #test':(evt, template)->
    console.log 'bigzhu'
    Meteor.loginWithGoogle({},  (err)->
      if (err)
        console.log err
    )

  'click #signOut':(evt)->
    Meteor.logout()
}

Meteor.startup(->
  Deps.autorun(->
    user = Meteor.user()
    if user
      if user.emails
        email = user.emails[0].address
        localStorage.setItem("userEmail", email)
        console.log(email)
        url = "http://www.gravatar.com/avatar/"+MD5(email);
        $("#user-avatar").attr("src",url)
        $("#user-email").html(email)
      else
        Meteor.call("getUserInfo",(error, userInfo)->
          email = userInfo.services.google.email
          localStorage.setItem("userEmail", email)
          console.log(email)
          url = "http://www.gravatar.com/avatar/"+MD5(email);
          $("#user-avatar").attr("src",url)
          $("#user-email").html(email)
        )
  )
)
