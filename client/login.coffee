Template.login.events = {
  'click #loginWithGoogle':(evt, template)->
    Meteor.loginWithGoogle({},  (err)->
      if (err)
        console.log err
      else
        Router.go('/common')
    )
}
