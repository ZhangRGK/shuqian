Template.bookMarkDetail.helpers({
  domain: ->
    a = document.createElement('a')
    #要取两次的奇怪问题
    if this.url
      a.href = this.url
    return a.hostname
  star:->
    if this.url
      Statistical.findOne({"url":this.url}).star
  black:->
    if this.url
      Statistical.findOne({"url":this.url}).black
  myTags:->
    if this.url
      myTags = []
      stat_tags = Statistical.findOne({"url":this.url}).tags
      for tag in this.tags
        if stat_tags.indexOf(tag.title)>=0
          myTags.push({"title":tag.title})
      return myTags
  otherTags:->
    if this.url
      otherTags = []
      stat_tags = Statistical.findOne({"url":this.url}).tags.slice(0)
      for tag in this.tags
        if stat_tags.indexOf(tag.title) >=0
          stat_tags.splice(stat_tags.indexOf(tag.title),1)
      for t in stat_tags
        otherTags.push({"title":t})
      return otherTags
})
