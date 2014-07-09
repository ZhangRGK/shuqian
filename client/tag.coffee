Template.tag.helpers({
  selected: ()->
    str = window.location.pathname
    arr = str.split('/')
    tag = decodeURIComponent(arr[arr.length - 1])
    if @title == tag
      return true
    else
      return false
})
