Meteor.publish('bookmarks', ->
  if this.userId
    return BookMarks.find({userId: @userId})
)

Meteor.publish('tags', ->
  if this.userId
    return Tags.find({userId: @userId})
)

Meteor.publish('statistical', (url)->
  #自已的tag
  if url == 'explore'
    #当前用户所有在用tag
    usingTags = Tags.find({userId: @userId, stat:1}).fetch()
    tagTitles = _.uniq(_.pluck(usingTags, "title"))
    #随机选3个标签
    randTags = randArray(tagTitles, 3)
    urlAreas = _.uniq(_.pluck(Tags.find({title: {$in:randTags}}).fetch(), "url"))

    #屏蔽曾经和当前收藏的和黑名单的url
    bms = _.pluck(BookMarks.find({userId: @userId}).fetch(), "url")
    tags = Tags.find({userId: @userId}).fetch()
    urls = _.pluck(tags, 'url').concat(bms)
    if urlAreas.length != 0
      where = {star: {$gt: 2}, black: {$lt: 3}, url: {$nin: urls, $in:urlAreas}}
    else
      where = {star: {$gt: 2}, black: {$lt: 3}, url: {$nin: urls}}
    #where = {star: {$gt: 1}, black: {$lt: 2}, count: {$gt: 3}, url: {$nin: urls, $in:urlAreas}}
    #where = {url: {$nin: urls}}

    #theOr = [
    #  {url: {$in: checkedBookMarks}},
    #  where
    #]

    statistical = Statistical.find(where, {sort: {start: -1, black: 1, count: -1}, limit: 4})
    if statistical.count() == 0
      where = {star: {$gt: 1}, black: {$lt: 3}, url: {$nin: urls}}
      statistical = Statistical.find(where, {sort: {start: -1, black: 1, count: -1}, limit: 4})
    return statistical
  else
    return Statistical.find({"url": url})
)

Meteor.publish("explores", ->
  sub = this
  subHandle = null

  #tags = Tags.find({userId:this.userId}).fetch()
  #bms = _.pluck(BookMarks.find({"userId":this.userId,"stat":2}).fetch(),"url")
  #urls = _.pluck(tags, 'url').concat(bms)

  subHandle = BookMarks.find({userId: {$ne: this.userId}}, {limit: 200}
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

Meteor.publish("FAQ", (keywords)->
#  if keywords == ""
#    return FAQ.find({"sort": {"count": -1}, "limit": 20})
#  else
#    return FAQ.find({"question":/[keyword]?/})
  return FAQ.find()
)

Meteor.methods({
  #增加统计表的次数
  addStatTag:(url, tag)->
    console.log tag
    if Statistical.find({"url": url}).count() == 0
      Statistical.insert({"url": url, "star": 1, "black": 0, "count": 0, "tags": [tag]})
    else
      stat = Statistical.findOne({"url": url})
      final = stat.tags.slice(0)
      if stat.tags.indexOf(tag) < 0
        final.push(tag)
      Statistical.update({"_id": stat._id}, {"$set": {"star": stat.star + 1, "tags": final}})
  increaseStatCount: (url)->
    statistical = Statistical.findOne({"url": url})
    Statistical.update({_id: statistical._id}, {$set: {"count": statistical.count + 1}})
  #当tag没有人用的时候从统计表中移除 标签stat==0
  removeStatTag:(url,title)->
    if Tags.find({"title": title,"stat":1}).count() == 0
      stat = Statistical.findOne({"url": url})
      final = stat.tags
      final.splice(final.indexOf(title),1)
      Statistical.update({"_id": stat._id}, {"$set": {"tags": final}})

})
