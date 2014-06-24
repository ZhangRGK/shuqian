@Tags = new Meteor.Collection('tags')
@Tags.allow({
  insert: (userId, doc)->
    return !! userId
  update: (userId, doc)->
    return !! userId
})
