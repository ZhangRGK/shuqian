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
    _.uniq(Tags.find({"stat":1,"userId":Meteor.userId()}),"title")
  otherTags:->
    _.uniq(Tags.find({"stat":1,"userId":{$ne:Meteor.userId()}}),"title")
  tagList:->
    if Meteor.userId()
      Tags.find({"userId":Meteor.userId()})
})
