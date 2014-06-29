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

Meteor.publish('not_mine_bookmarks', ->
  tags = Tags.find({userId:this.userId}).fetch()
  urls = _.pluck(tags, 'url')
  return BookMarks.find({url: {$nin: urls}, stat:1}, {sort:{count:-1}, limit : 14})
)

