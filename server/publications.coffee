Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId: this.userId, stat: 1})
  else
    return BookMarks.find({userId: '', stat: 1})
)

Meteor.publish('ddp_bookmarks', (userId)->
  return BookMarks.find({userId: userId, stat: 1})
)

Meteor.publish('tags', ->
  if this.userId
    return Tags.find({userId: this.userId, stat: 1})
  else
    return Tags.find({userId: '', stat: 1})
)

Meteor.publish('ddp_tags', (userId)->
  return Tags.find({userId: userId, stat: 1})
)

