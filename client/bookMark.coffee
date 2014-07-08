Template.bookMark.helpers({
  domain: ->
    a = document.createElement('a')
    a.href = this.url
    return a.hostname
  ,
  encodeURL:->
    encodeURIComponent(this.url)
  ,
  isExplore:->
    window.location.pathname == "/explore"
  date:->
    d = new Date(@dateAdded)
    return d.getFullYear()+"年"+(d.getMonth()+1)+"月"+(d.getDay()+1)+"日"
})
Template.bookMark.events = {
  'click .url':  (evt, template)->
    increaseBookMarkCount(this.url)
    evt.stopPropagation()
  'click .remove': (evt, template)->
    if window.location.pathname == "/explore"
      bm = this.constructor()
      bm.userId = Meteor.userId()
      bm.url = this.url
      bm.title = this.title
      bm.stat = 2
      bm.dateAdded = new Date().getTime()
      BookMarks.insert(bm)
    evt.stopPropagation()
    return
  'click input[name="bookmark"]': (evt, template)->
    if $(evt.target).is(':checked')
      setCheckedBookMarks($(evt.target).val())
    else
      popCheckedBookMarks($(evt.target).val())
    showMultith()
    evt.stopPropagation()
  'click .list-group-item': (evt, template)->
    $(evt.target).find('input[name="bookmark"]').click()
}
