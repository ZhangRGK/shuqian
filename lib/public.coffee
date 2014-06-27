@addTag = (bookMark, tag, userId=null)->
  console.log userId
  if userId == null
    userId = Meteor.userId()
  #查找是否是在其他用户的bookmark上加tag,如果是,copy到自已的上面来.
  findBookMark = {userId:userId, url:bookMark.url, title:bookMark.title}
  if BookMarks.find(findBookMark).count() == 0
    insertBookMark = {userId:userId, url:bookMark.url, title:bookMark.title, dateAdded:Date.parse(new Date())}
    BookMarks.insert(insertBookMark)

  tag = {userId:userId, url:bookMark.url, title:tag}
  findTag = Tags.findOne(tag)
  if findTag
    Tags.update({_id:findTag._id}, {$set: {stat:1}})
  else
    tag.stat=1
    Tags.insert(tag)

@increaseBookMarkCount = (url)->
  userId = Meteor.userId()
  if userId
    bookMark = BookMarks.findOne({url:url, userId:userId})
    if bookMark.count 
      count = bookMark.count+1
    else
      count = 1
    console.log count
    console.log BookMarks.update({_id:bookMark._id}, {$set: {count:count}})
    console.log BookMarks.findOne({url:url, userId:userId})
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
