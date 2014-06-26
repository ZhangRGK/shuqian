Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId:this.userId})
  else
    return BookMarks.find({userId:null})
)

Meteor.publish('ddp_bookmarks', (userId)->
  return BookMarks.find({userId: userId, stat: 1})
)

Meteor.publish('tags', ->
  if this.userId
      return Tags.find({userId:this.userId})
    else
      return Tags.find({userId:''})
)

Meteor.publish('ddp_tags', (userId)->
  return Tags.find({userId: userId, stat: 1})
)


Meteor.publish('all_bookmarks', ->
  return BookMarks.find()
)
