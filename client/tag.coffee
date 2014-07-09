Template.tag.helpers({
  selected: ()->
    if window.location.pathname == '/explore'
      return false
    else
      str = window.location.pathname
      arr = str.split('/')
      tag = decodeURIComponent(arr[arr.length - 1])
      if @title == tag
        return true
      else
        return false
})
