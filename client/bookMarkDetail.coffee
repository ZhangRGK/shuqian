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
    if Meteor.userId()
      return _.uniq(Tags.find({"stat":1,"userId":Meteor.userId()}).fetch(),"title")
    else
      return _.uniq(Tags.find({"stat":1}),"title")
  otherTags:->
    if Meteor.userId()
      return _.uniq(Tags.find({"stat":1,"userId":{$ne:Meteor.userId()}}).fetch(),"title")
    else
      return _.uniq(Tags.find({"stat":1}).fetch(),"title")
  tags:->
    console.log(Meteor.userId())
    if Meteor.userId()
      console.log(Tags.find({"userId":Meteor.userId()}).fetch())
      return Tags.find({"userId":Meteor.userId()}).fetch()
    else
      return _.uniq(Tags.find().fetch(),"title")
})
