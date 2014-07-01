Template.bookMarkDetail.helpers({
  domain: ->
    a = document.createElement('a')
    #要取两次的奇怪问题
    if @bookMark
      a.href = this.bookMark.url
    return a.hostname
  star:->
    BookMarks.find({"stat":1}).count()
  black:->
    BookMarks.find({"stat":2}).count()
  myTags:->
    Tags.find("stat":1,"userId":Meteor.userId())
  otherTags:->
    Tags.find("stat":1,"userId":{$ne:Meteor.userId()})
})
