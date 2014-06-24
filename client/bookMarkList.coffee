Template.bookMarkList.helpers({
  #otherTags: ->
  #  if @tags
  #    _.reject(@tags, (d)=> d.title == @tag)
  #  else
  #    return
  uniqTag:->
    #$('.multiselect').multiselect('select', @tag)
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
        tag.selected = selected
        if(tag.selected)
          $('.multiselect').multiselect('select', selectTag.title)
        else
          $('.multiselect').multiselect('deselect', selectTag.title)

  Session.set('uniqTag', uniqTag)

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
