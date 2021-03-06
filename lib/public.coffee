@removeTag = (bookMarkUrl, tag)->
  tag = {userId: Meteor.userId(), url: bookMarkUrl, title: tag, stat: 1}
  doTag = Tags.findOne(tag)
  #选择多个checkbox时,会出现剔除没有标记这个tag的bookmakrs的情况
  if !doTag
    return

  Tags.update({_id: doTag._id}, {$set: {stat: 0}})

  Meteor.call('removeStatTag', bookMarkUrl, tag.title)

#  stat = Statistical.findOne({"url": bookMark.url})
#  final = stat.tags.slice(0)
#  final.splice(final.indexOf(tag.title),1)
#  Statistical.update({"_id": stat._id}, {"$set": {"star": stat.star-1, "tags": final}})

@addTag = (bookMark, tag, userId = null)->
  if userId == null
    userId = Meteor.userId()
  #查找是否是在其他用户的bookmark上加tag,如果是,copy到自已的上面来.
  whereBookMark = {userId: userId, url: bookMark.url, title: bookMark.title}
  if BookMarks.find(whereBookMark).count() == 0
    insertBookMark = {userId: userId, url: bookMark.url, title: bookMark.title, dateAdded: Date.parse(new Date()), stat: 1}
    BookMarks.insert(insertBookMark)
  else
    whereBookMark.stat = 2
    findBookMark = BookMarks.findOne(whereBookMark)
    #如果是在黑名单里
    if findBookMark
      BookMarks.update({_id: findBookMark._id}, {$set: {stat: 1, dateAdded: Date.parse(new Date())}})
  tag = {userId: userId, url: bookMark.url, title: tag}
  findTag = Tags.findOne(tag)
  if findTag
    Tags.update({_id: findTag._id}, {$set: {stat: 1}})
  else
    tag.stat = 1
    Tags.insert(tag)
  # 增加统计表
  Meteor.call('addStatTag', bookMark.url, tag.title)
# 统计表修改完成

@increaseBookMarkCount = (url)->
  Meteor.call('increaseStatCount', url)
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
  BookMarks.update({_id: bookMark._id}, {$set: {"count": count}})

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

#取bookMark
@getBookmarkById = (bookMarkId)->
  bookMark = BookMarks.findOne({_id: bookMarkId})
  console.log bookMark
  if !bookMark
    bookMark = Statistical.findOne({_id: bookMarkId})
    bookMark.userId = Meteor.userId()
  return bookMark

@getBookmarkByUrl = (url)->
  bookMark = BookMarks.findOne({"url":url,"userId":Meteor.userId()})
  if !bookMark
    stat = Statistical.findOne({"url":url})
    bookMark = {"url":url,"title":stat.title}
  return bookMark

@setCheckedBookMarks = (bookMarkId)->
  bookMarks = Session.get("checkedBookMarks")
  if !bookMarks
    bookMarks = []
  bookMarks.push(bookMarkId)
  bookMarks = _.uniq(bookMarks)
  Session.set("checkedBookMarks", bookMarks)
@popCheckedBookMarks = (bookMarkId)->
  bookMarks = Session.get("checkedBookMarks")
  bookMarks.splice(bookMarks.indexOf(bookMarkId), 1)
  Session.set("checkedBookMarks", bookMarks)
@cleanCheckedBookMarks = ->
  Session.set("checkedBookMarks", [])

@showMultith = ->
  $('option', $('#multi')).each((element)->
    $(this).removeAttr('selected').prop('selected', false)
  )
  $('#multi').multiselect('refresh')

  if $('input[name="bookmark"]:checked').val()
    $('#multith').css({visibility: "visible"})
  else
    $('#multith').css({visibility: "hidden"})

  $('input[name="bookmark"]:checked').map(->
    url = $(this).val()
    selectTags = Tags.find({url: url, stat: 1}).fetch()
    for selectTag in selectTags
      $('#multi').multiselect('select', selectTag.title)
  )
@randArray = (m, len)->
    m.sort(-> return Math.random() - 0.5)
    return m.slice(0, len)
