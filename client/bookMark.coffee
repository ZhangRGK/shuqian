Template.bookMark.helpers({
  domain: ->
    a = document.createElement('a')
    a.href = this.url
    return a.hostname
  ,
  encodeURL:->
    encodeURIComponent(this.url)
  ,
  flag:->
    console.log this
    tags = Tags.find({url:this.url, stat:1}).fetch()
    console.log tags.length
    f = false
    if(tags.length == 0)
      f = true
    return f
  date:->
    console.log 'xxx'
    d = new Date(@dateAdded)
    return d.getFullYear()+"年"+(d.getMonth()+1)+"月"+(d.getDay()+1)+"日"
})
Template.bookMark.events = {
  'click #tagUrl':  (evt, template)->
    increaseBookMarkCount(this.url)
    console.log 'x'
  'click #tagDel': (evt, template)->
    console.log this
    BookMarks.update({_id:this._id}, {$set: {stat:2}})

}
