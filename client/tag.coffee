Template.tag.helpers({
  selected: ()->
    tag = Session.get('tag')
    if @title == tag
      return true
    else
      return false
})
