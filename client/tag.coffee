Template.tag.helpers({
  selected: ()->
    tag = Session.get('shuqianTag')
    if @title == tag
      return true
    else
      return false
})
