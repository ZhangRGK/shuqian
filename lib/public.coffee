@removeTag = (bookMarkId, tag)->
  bookMark = getBookmark(bookMarkId)
  tag = {userId:Meteor.userId(), url:bookMark.url, title:tag, stat:1}
  doTag = Tags.findOne(tag)
  #选择多个checkbox时,会出现剔除没有标记这个tag的bookmakrs的情况
  if !doTag
    return

  Tags.update({_id:doTag._id}, {$set: {stat:0}})
  stat = Statistical.findOne({"url": bookMark.url})
  final = stat.tags.slice(0)
  final.splice(final.indexOf(tag),1)
  Statistical.update({"_id": stat._id}, {"$set": {"star": stat.star-1, "tags": final}})

@addTag = (bookMark, tag, userId = null)->
  if userId == null
    userId = Meteor.userId()
  #查找是否是在其他用户的bookmark上加tag,如果是,copy到自已的上面来.
  whereBookMark = {userId:userId, url:bookMark.url, title:bookMark.title}
  if BookMarks.find(whereBookMark).count() == 0
    insertBookMark = {userId:userId, url:bookMark.url, title:bookMark.title, dateAdded:Date.parse(new Date()), stat:1}
    BookMarks.insert(insertBookMark)
  else
    whereBookMark.stat = 2
    findBookMark = BookMarks.findOne(whereBookMark)
    #如果是在黑名单里
    if findBookMark
      BookMarks.update({_id:findBookMark._id}, {$set: {stat:1, dateAdded:Date.parse(new Date())}})
  tag = {userId:userId, url:bookMark.url, title:tag}
  findTag = Tags.findOne(tag)
  if findTag
    Tags.update({_id: findTag._id}, {$set: {stat: 1}})
  else
    tag.stat = 1
    Tags.insert(tag)
  # 修改统计表
  if Statistical.find({"url": bookMark.url}).count() == 0
    Statistical.insert({"url": bookMark.url, "star": 1, "black": 0, "count": 0, "tags": [tag]})
  else
    stat = Statistical.findOne({"url": bookMark.url})
    final = stat.tags.slice(0)
    if stat.tags.indexOf(tag) < 0
      final.push(tag)
    Statistical.update({"_id": stat._id}, {"$set": {"star": stat.star+1, "tags": final}})
  # 统计表修改完成

@increaseBookMarkCount = (url)->
  statistical = Statistical.findOne({"url":url})
  if statistical
    Statistical.update({_id:statistical._id},{$set:{"count":statistical.count+1}})

  userId = Meteor.userId()
  if !userId
    userId = ''
  bookMark = BookMarks.findOne({url: url, userId: userId})
  if !bookMark
    return

  if bookMark.count
    count = bookMark.count + 1
  else
    count = 1
  BookMarks.update({_id:bookMark._id},{$set:{"count":count}})

#铺平
@spread = (node, nodes)->
  temp = {}
  for key of node
    if key != 'children'
      temp[key] = node[key]
    else
      for i in node[key]
        spread(i, nodes)
  nodes.push(temp)

#探索
@explore = ->
  tags = Tags.find({userId:Meteor.userId()}).fetch()
  bms = _.pluck(BookMarks.find({"userId":Meteor.userId()}).fetch(),"url")
  urls = _.pluck(tags, 'url').concat(bms)
  #Explores.find({url: {$nin: urls}, stat:1}, {sort:{count:-1}, limit : 200})
  checkedBookMarks = Session.get("checkedBookMarks")||[]
  theOr = [{ _id: {$in: checkedBookMarks}}, {url: {$nin: urls}, stat:1}]
  Explores.find({$or: theOr}, {sort:{count:-1}, limit : 200})
#取bookMark
@getBookmark = (bookMarkId)->
  bookMark = BookMarks.findOne({_id: bookMarkId})
  if !bookMark
    bookMark = Explores.findOne({_id: bookMarkId})
    bookMark.userId = Meteor.userId()
  return bookMark
@setCheckedBookMarks = (bookMarkId)->
    bookMarks = Session.get("checkedBookMarks")
    if !bookMarks
      bookMarks = []
    bookMarks.push(bookMarkId)
    Session.set("checkedBookMarks", bookMarks)
@popCheckedBookMarks = (bookMarkId)->
    bookMarks = Session.get("checkedBookMarks")
    bookMarks.splice(bookMarks.indexOf(bookMarkId),1)
    Session.set("checkedBookMarks", bookMarks)
@cleanCheckedBookMarks = ->
    Session.set("checkedBookMarks", [])
