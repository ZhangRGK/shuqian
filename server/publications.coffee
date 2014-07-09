Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId:this.userId})
)

Meteor.publish('tags', ->
  if this.userId
      return Tags.find({userId:this.userId})
)

Meteor.publish('statistical',(url, checkedBookMarks)->
  #自已的tag
  if url == 'explore'
    tags = Tags.find({userId: @userId}).fetch()
    tagTitles = _.pluck(tags, "title")

    #屏蔽曾经和当前收藏的和黑名单的
    bms = _.pluck(BookMarks.find({"userId": @userId}).fetch(), "url")
    urls = _.pluck(tags, 'url').concat(bms)

    #屏蔽被其他人列入黑名单内的
    where = {star: {$gt: 1}, black: {$lt: 2}, count: {$gt: 3}, url: {$nin: urls}}
    #checkedBookMarks = Session.get("checkedBookMarks") || []
    theOr = [
      { _id: {$in: checkedBookMarks}},
      where
    ]
    statistical = Statistical.find({$or: theOr}, {sort: {start: -1, black: 1, count: -1}, limit: 20})
    #statistical = Statistical.find({},limit: 10)
    return statistical
  else
    return Statistical.find({"url":url})
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
