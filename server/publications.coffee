Meteor.publish('bookmarks', (userId)->
  user = Meteor.users.findOne({_id:userId})
  if user==undefined
    #return null
    return BookMarks.find()
  else
    return BookMarks.find()
)
Meteor.publish('tags', ->
  return Tags.find()
)

