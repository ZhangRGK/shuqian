Template.bookMarkDetail.helpers({
  domain: ->
    a = document.createElement('a')
    #要取两次的奇怪问题
    if @bookMark
      a.href = this.bookMark.url
    return a.hostname
  star:->
    BookMarks.find({"stat":1,"url":this.bookMark.url}).count()
  black:->
    BookMarks.find({"stat":2,"url":this.bookMark.url}).count()
  myTags:->
    if Meteor.userId()
      return _.uniq(Tags.find({"stat":1,"userId":Meteor.userId(),"url":this.bookMark.url}).fetch(),false,(d)->d.title)
    else
      return _.uniq(Tags.find({"stat":1,"url":this.bookMark.url}),false,"title")
  otherTags:->
    if Meteor.userId()
      return _.uniq(Tags.find({"stat":1,"url":this.bookMark.url,"userId":{$ne:Meteor.userId()}}).fetch(),false,(d)->d.title)
    else
      return _.uniq(Tags.find({"stat":1,"url":this.bookMark.url}).fetch(),false,(d)->d.title)
})
