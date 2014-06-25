Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId:this.userId})
  else
    return BookMarks.find({userId:''})
)

Meteor.publish('tags', ->
  if this.userId
      return Tags.find({userId:this.userId})
    else
      return Tags.find({userId:''})
)

