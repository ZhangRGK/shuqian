Template.login.events = {
  'click #openLogin':(evt, template)->
    Meteor.loginWithGoogle({},  (err)->
      if (err)
        console.log err
      else
        Router.go('/common')
    )
}
