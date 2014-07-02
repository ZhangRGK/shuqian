@addTag = (bookMark, tag, userId=null)->
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
    Tags.update({_id:findTag._id}, {$set: {stat:1}})
  else
    tag.stat=1
    Tags.insert(tag)

@increaseBookMarkCount = (url)->
  userId = Meteor.userId()
  if userId
    bookMark = BookMarks.findOne({url:url, userId:userId})
    if !bookMark
      return
    if bookMark.count
      count = bookMark.count+1
    else
      count = 1
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

@explore = ->
  tags = Tags.find({userId:Meteor.userId()}).fetch()
  bms = _.pluck(BookMarks.find({"userId":Meteor.userId()}).fetch(),"url")
  urls = _.pluck(tags, 'url').concat(bms)
  Explores.find({url: {$nin: urls}, stat:1}, {sort:{count:-1}, limit : 200})
