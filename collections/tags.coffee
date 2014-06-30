@Tags = new Meteor.Collection('tags')
@Tags.allow({
  insert: (userId, data)->
    if userId
      return userId == data.userId
    else
      return false
  update: (userId, data)->
    if userId
      return userId == data.userId
    else
      return false
  remove: (userId, data)->
    if userId
      return userId == data.userId
    else
      return false
})
