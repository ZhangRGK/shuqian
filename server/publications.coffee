


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

Meteor.publish("explores", ->
  sub = this
  subHandle = null

  #tags = Tags.find({userId:this.userId}).fetch()
  #bms = _.pluck(BookMarks.find({"userId":this.userId,"stat":2}).fetch(),"url")
  #urls = _.pluck(tags, 'url').concat(bms)

  subHandle = BookMarks.find({userId: {$ne: this.userId}}
  ).observeChanges({
      added: (id, fields)->
        sub.added("explores", id, fields)
      changed: (id, fields)->
        sub.changed("explores", id, fields)
      removed: (id)->
        sub.removed("explores", id)
    })

  sub.ready()

  sub.onStop(->
    subHandle.stop()
  )
)
