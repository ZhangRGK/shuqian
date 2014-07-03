Template.bookMarkDetail.helpers({
  domain: ->
    a = document.createElement('a')
    #要取两次的奇怪问题
    if @bookMark
      a.href = this.bookMark.url
    return a.hostname
  star:->
    Statistical.findOne({"url":this.bookMark.url}).star
  black:->
    Statistical.findOne({"url":this.bookMark.url}).black
  myTags:->
    myTags = []
    stat_tags = Statistical.findOne({"url":this.bookMark.url}).tags
    for tag in this.tags
      if stat_tags.indexOf(tag)>=0
        myTags.push(stat_tags[stat_tags.indexOf(tag)])
    return myTags
  otherTags:->
    stat_tags = Statistical.findOne({"url":this.bookMark.url}).tags.slice(0)
    for tag in this.tags
      if stat_tags.indexOf(tag) >=0
        stat_tags.splice(stat_tags.indexOf(tag),1)
    return stat_tags
})
