@addTag = (bookMark, tag, userId = null)->
  if userId == null
    userId = Meteor.userId()
  #查找是否是在其他用户的bookmark上加tag,如果是,copy到自已的上面来.
  findBookMark = {userId: userId, url: bookMark.url, title: bookMark.title}
  if BookMarks.find(findBookMark).count() == 0
    insertBookMark = {userId: userId, url: bookMark.url, title: bookMark.title, dateAdded: Date.parse(new Date()), stat: 1}
    BookMarks.insert(insertBookMark)
  # 修改统计表
  if Statistical.find({"url": bookMark.url}).count() == 0
    Statistical.insert({"url": bookMark.url, "star": 1, "black": 0, "count": 0, "tags": [tag]})
  else
    stat = Statistical.findOne({"url": bookMark.url})
    final = tags.slice(0)
    if tags.indexOf(tag) < 0
      final.push(tag)
    Statistical.update({"url": bookMark.url}, {"$set": {"star": stat.star+1, "tags": final}})
  # 统计表修改完成
  tag = {userId: userId, url: bookMark.url, title: tag}
  findTag = Tags.findOne(tag)
  if findTag
    Tags.update({_id: findTag._id}, {$set: {stat: 1}})
  else
    tag.stat = 1
    Tags.insert(tag)

@increaseBookMarkCount = (url)->
  userId = Meteor.userId()
  if userId
    userId = ""
  bookMark = BookMarks.findOne({url: url, userId: userId})
  if !bookMark
    return
  stat_count = Statistical.findOne({"url":url})
  Statistical.update({"url":url},{"$set":{"count":stat_count+1}})
  if bookMark.count
    count = bookMark.count + 1
  else
    count = 1
  BookMarks.update({"url":url,"userId":userId},{"$set":{"count":count}})
  return

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
