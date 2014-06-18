Meteor.publish('bookmarks', ->
  return BookMarks.find()
)
Meteor.publish('tags', ->
  return Tags.find()
)

