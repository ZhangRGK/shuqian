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
      myTags = []
      stat_tags = @statistical.tags
      for tag in this.tags
        if stat_tags.indexOf(tag.title)>=0
          myTags.push({"title":tag.title})
      return myTags
  otherTags:->
    if @statistical
      otherTags = []
      stat_tags = @statistical.tags.slice(0)
      for tag in this.tags
        if stat_tags.indexOf(tag.title) >=0
          stat_tags.splice(stat_tags.indexOf(tag.title),1)
      for t in stat_tags
        otherTags.push({"title":t})
      return otherTags
})

Template.bookMarkDetail.events = {
  'click a[name="myTags"]': (evt, template)->
    url = $('a[name="bookmarkUrl"]').prop('text')
    tag = $(evt.target).html()
    bookMark = getBookmarkByUrl(url)
    removeTag(bookMark._id, tag)
  ,
  'click a[name="otherTags"]':(evt,template)->
    url = $('a[name="bookmarkUrl"]').prop('text')
    tag = $(evt.target).html()
    bookMark = getBookmarkByUrl(url)
    addTag(bookMark,tag)
}
