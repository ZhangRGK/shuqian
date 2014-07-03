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
    currentType = Session.get('shuqianType')
    return currentType == 'explore'
  date:->
    d = new Date(@dateAdded)
    return d.getFullYear()+"年"+(d.getMonth()+1)+"月"+(d.getDay()+1)+"日"
})
Template.bookMark.events = {
  'click .url':  (evt, template)->
    increaseBookMarkCount(this.url)
  'click .remove': (evt, template)->
    currentType = Session.get('shuqianType')
    if currentType == "garbage"
      BookMarks.update({_id:this._id}, {$set: {stat:2,dateAdded:new Date().getTime()}})
    else if currentType == "explore"
      bm = this.constructor()
      bm.userId = Meteor.userId()
      bm.url = this.url
      bm.title = this.title
      bm.stat = 2
      bm.dateAdded = new Date().getTime()
      BookMarks.insert(bm)
    return
}
