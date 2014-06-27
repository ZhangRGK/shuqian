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
      bookMark = BookMarks.findOne({_id:bookMarkId})
      tag = $('#tagname').val()
      $('#tagname').val('')
      addTag(bookMark, tag)
    )
  ,
  'keypress #tagname':(evt, template)->
    #evt.stopPropagation()
    if evt.keyCode==13
      $('#myModal').modal('hide')
      #禁止界面刷新
      evt.preventDefault()
      $('input[name="bookmark"]:checked').map(->
        bookMarkId = $(this).val()
        bookMark = BookMarks.findOne({_id:bookMarkId})
        tag = $('#tagname').val()
        $('#tagname').val('')
        addTag(bookMark, tag)
      )
}

Meteor.startup(->
  Meteor.absoluteUrl.defaultOptions.rootUrl = "http://shuqian.bigzhu.org"
  Deps.autorun(->
    if Meteor.user()
      localStorage.setItem("userEmail", Meteor.user().emails[0].address)
  )
)
