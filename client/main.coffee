Template.main.events = {
  'keyup #search': (evt, template)->
    value = $(evt.target).val()
    console.log(value)
    if value == ''
      Router.go('/')
    else
      Router.go('/search/' + value)
  ,
  'click #savetagbtn':(evt, template)->
    $('#myModal').modal('hide')
    $('input[name="bookmark"]:checked').map(->
      bookMarkId = $(this).val()
      tag = $('#tagname').val()
      addTag(bookMarkId, tag)
    )
  ,
  'keypress #tagname':(evt, template)->
    evt.stopPropagation()
    if evt.keyCode==13
      $('#myModal').modal('hide')
      $('input[name="bookmark"]:checked').map(->
        bookMarkId = $(this).val()
        tag = $('#tagname').val()
        addTag(bookMarkId, tag)
      )

}

Meteor.startup(->
  Deps.autorun(->
    if Meteor.user()
      localStorage.setItem("userEmail", Meteor.user().emails[0].address)
  )
)
