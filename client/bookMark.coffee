Template.bookMark.helpers({
  domain: ->
    a = document.createElement('a')
    a.href = this.url
    return a.hostname
  ,
  encodeURL:->
    encodeURIComponent(this.url)
  ,
  date:->
    console.log @dateAdded
    d = new Date(@dateAdded)
    return d.getFullYear()+"年"+(d.getMonth()+1)+"月"+(d.getDay()+1)+"日"
})
