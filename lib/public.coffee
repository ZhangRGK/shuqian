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
