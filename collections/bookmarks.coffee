@BookMarks = new Meteor.Collection('bookmarks')
BookMarks.allow({
  remove: (userId, data)->
    if userId
      return userId == data.userId
    else
      return false
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
})
if Meteor.isClient
  @Explores = new Meteor.Collection("explores")
