Template.main.events = {
  'keyup #search': (evt, template)->
    value = $(evt.target).val()
    console.log(value)
    if value == ''
      Router.go('/')
    else
      Router.go('/search/' + value)
  'click #savetagbtn':(evt, template)->
    $('#myModal').modal('hide')
    $('input[name="bookmark"]:checked').map(->
      bookMarkId = $(this).val()

      bookMark = BookMarks.findOne({_id:bookMarkId})

      tag = {userId:Meteor.userId(), url:bookMark.url, title:$('#tagname').val()}
      findTag = Tags.findOne($('#tagname').val())
      if findTag
        Tags.update({_id:findTag._id}, {$set: {stat:1}})
      else
        tag.stat=1
        Tags.insert(tag)
    )
}

Meteor.startup(->
  Deps.autorun(->
    if Meteor.user()
      localStorage.setItem("userEmail", Meteor.user().emails[0].address)
  )
)
