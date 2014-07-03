Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId:this.userId})
  else
    return BookMarks.find({userId:''}, limit : 200)
)

Meteor.publish('tags', ->
  if this.userId
      return Tags.find({userId:this.userId})
    else
      return Tags.find({userId:''}, limit : 200)
)

Meteor.publish('statistical',()->
#  urls = []
#  if this.userId
#    urls = BookMarks.find({userId:this.userId},{"fields":{"url":true,"_id":false}}).fetch()
#  else
#    urls = BookMarks.find({userId:''},{"fields":{"url":true,"_id":false}}).fetch()
#  console.log(this.userId)
#  console.log(urls)
  return Statistical.find()
)

Meteor.publish("explores", ->
  sub = this
  subHandle = null

  #tags = Tags.find({userId:this.userId}).fetch()
  #bms = _.pluck(BookMarks.find({"userId":this.userId,"stat":2}).fetch(),"url")
  #urls = _.pluck(tags, 'url').concat(bms)

  subHandle = BookMarks.find({userId: {$ne: this.userId}},{limit : 200}
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
