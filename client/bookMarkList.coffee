Template.bookMarkList.helpers({
  #otherTags: ->
  #  if @tags
  #    _.reject(@tags, (d)=> d.title == @tag)
  #  else
  #    return
  uniqTag:->
    Session.get('uniqTag')
})
toggle = (evt, selected)->
  id = $(evt.target).val()
  bookMark = BookMarks.findOne({_id:id})
  selectTags = Tags.find({url:bookMark.url}).fetch()
  
  uniqTag = Session.get('uniqTag')
  
  for selectTag in selectTags
    for tag in uniqTag
      if selectTag.title == tag.title
        console.log selectTag.title
        tag.selected = selected
  Session.set('uniqTag', uniqTag)
  console.log Session.get('uniqTag')
Template.bookMarkList.events = {
  'click #editor':  (evt, template)->
    $('input[type="checkbox"]').toggle()
  ,
  'click input[type="checkbox"]':  (evt, template)->
    if $(evt.target).prop('checked')
      toggle(evt, true)
    else
      toggle(evt, false)
}
