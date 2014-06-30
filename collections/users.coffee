Meteor.methods({
  getUserInfo:(userId)->
    Meteor.user().find({_id:userId})
})
