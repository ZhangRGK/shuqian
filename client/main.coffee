Template.main.events = {
  'keyup #search': (evt, template)->
    value = $(evt.target).val()
    console.log(value)
    if value == ''
      Router.go('/')
    else
      Router.go('/search/' + value)
}

Meteor.startup(->
  Deps.autorun(->
    if Meteor.user()
      localStorage.setItem("userName", Meteor.user().emails[0].address)
  )
)
