Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId:this.userId})
  else
    return BookMarks.find({userId:''})
)

Meteor.publish('tags', ->
  return Tags.find()

#if this.userId
#    return Tags.find({userId:this.userId})
#  else
#    console.log 'tag userId is null'
#    return Tags.find({userId:''})
)

