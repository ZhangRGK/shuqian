Template.bookMarkDetail.helpers({
  domain: ->
    a = document.createElement('a')
    #要取两次的奇怪问题
    if this.bookMark
      a.href = this.bookMark.url
    return a.hostname
  star:->
    console.log this.bookMark
    if this.bookMark
      Statistical.findOne({"url":this.bookMark.url}).star
  black:->
    if @bookMark
      Statistical.findOne({"url":this.bookMark.url}).black
  myTags:->
    if @bookMark
      myTags = []
      stat_tags = Statistical.findOne({"url":this.bookMark.url}).tags
      for tag in this.tags
        if stat_tags.indexOf(tag.title)>=0
          myTags.push({"title":tag.title})
      return myTags
  otherTags:->
    if @bookMark
      otherTags = []
      stat_tags = Statistical.findOne({"url":this.bookMark.url}).tags.slice(0)
      for tag in this.tags
        if stat_tags.indexOf(tag.title) >=0
          stat_tags.splice(stat_tags.indexOf(tag.title),1)
      for t in stat_tags
        otherTags.push({"title":t})
      return otherTags
})
