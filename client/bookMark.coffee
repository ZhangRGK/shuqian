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
    f = false
    if(currentType == 'garbage' || currentType == 'explore')
      f = true
    return f
  date:->
    d = new Date(@dateAdded)
    return d.getFullYear()+"年"+(d.getMonth()+1)+"月"+(d.getDay()+1)+"日"
})
Template.bookMark.events = {
  'click #tagUrl':  (evt, template)->
    increaseBookMarkCount(this.url)
  'click #tagDel': (evt, template)->
    currentType = Session.get('shuqianType')
    if currentType == "garbage"
      BookMarks.update({_id:this._id}, {$set: {stat:2}})
    else if currentType == "explore"
      bm = this.constructor()
      bm.userId = Meteor.userId
      bm.url = this.url
      bm.title = this.title
      bm.stat = 2
      console.log(bm)
      BookMarks.insert(bm)
}
