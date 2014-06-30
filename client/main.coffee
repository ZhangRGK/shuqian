Template.main.events = {
  'keyup #search': (evt, template)->
    value = $(evt.target).val()
    if value == ''
      Router.go('/')
    else
      Router.go('/search/' + value)
  ,
  'click #savetagbtn':(evt, template)->

    $('#myModal').modal('hide')
    tag = $('#tagname').val()
    $('#tagname').val('')
    $('input[name="bookmark"]:checked').map(->
      bookMarkId = $(this).val()
      bookMark = BookMarks.findOne({_id:bookMarkId})
      addTag(bookMark, tag)
    )
  ,
  'keypress #tagname':(evt, template)->
    if evt.keyCode==13
      $('#myModal').modal('hide')
      #禁止界面刷新
      evt.preventDefault()
      tag = $('#tagname').val()
      $('#tagname').val('')
      $('input[name="bookmark"]:checked').map(->
        bookMarkId = $(this).val()
        bookMark = BookMarks.findOne({_id:bookMarkId})
        addTag(bookMark, tag)
      )
}

Meteor.startup(->
  Deps.autorun(->
    user = Meteor.user()
    if user
      if user.emails
        email = user.emails[0].address
        localStorage.setItem("userEmail", email)
      else
        Meteor.call("getUserInfo",(error, userInfo)->
          localStorage.setItem("userEmail", userInfo.services.google.email)
        )
  )
)
