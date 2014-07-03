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
    window.location.pathname == "/explore"
  date:->
    d = new Date(@dateAdded)
    return d.getFullYear()+"年"+(d.getMonth()+1)+"月"+(d.getDay()+1)+"日"
})
Template.bookMark.events = {
  'click .url':  (evt, template)->
    increaseBookMarkCount(this.url)
  'click .remove': (evt, template)->
    if window.location.pathname == "/explore"
      bm = this.constructor()
      bm.userId = Meteor.userId()
      bm.url = this.url
      bm.title = this.title
      bm.stat = 2
      bm.dateAdded = new Date().getTime()
      BookMarks.insert(bm)
    return
}
