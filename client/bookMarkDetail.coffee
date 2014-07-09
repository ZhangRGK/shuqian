Template.bookMarkDetail.helpers({
  domain: ->
    a = document.createElement('a')
    #要取两次的奇怪问题
    if this.url
      a.href = this.url
    return a.hostname
  bmTitle: ->
    if @statistical
      @statistical.title
  star:->
    if @statistical
      @statistical.star
  black:->
    if @statistical
      @statistical.black
  myTags:->
    if @statistical
      allTags = Tags.find({"url":@statistical.url,stat:1}).fetch()
      myTags = []
      stat_tags = @statistical.tags
      for tag in allTags
        if stat_tags.indexOf(tag.title)>=0
          myTags.push({"title":tag.title})
      return myTags
  otherTags:->
    if @statistical
      allTags = Tags.find({"url":@statistical.url,stat:1}).fetch()
      otherTags = []
      stat_tags = @statistical.tags.slice(0)
      for tag in allTags
        if stat_tags.indexOf(tag.title) >=0
          stat_tags.splice(stat_tags.indexOf(tag.title),1)
      for t in stat_tags
        otherTags.push({"title":t})
      return otherTags
})

Template.bookMarkDetail.events = {
  'click a[name="myTags"]': (evt, template)->
    #没有登录就返回
    if(!Meteor.userId())
      return

    url = $('a[name="bookmarkUrl"]').prop('text')
    tag = $(evt.target).html()
    removeTag(url, tag)
  ,
  'click a[name="otherTags"]':(evt,template)->
    #没有登录就返回
    if(!Meteor.userId())
      return
    url = $('a[name="bookmarkUrl"]').prop('text')
    tag = $(evt.target).html()
    bookMark = getBookmarkByUrl(url)
    addTag(bookMark,tag)
}
