toggle = (evt, selected)->
  id = $(evt.target).val()
  bookMark = BookMarks.findOne({_id:id})
  selectTags = Tags.find({url:bookMark.url}).fetch()

  tags = Tags.find().fetch()
  uniqTag = _.uniq(tags, false, (d)-> return d.title)

  for selectTag in selectTags
    for tag in uniqTag
      if selectTag.title == tag.title
        tag.selected = selected
        if(tag.selected)
          $('#multi').multiselect('select', selectTag.title)
        else
          $('#multi').multiselect('deselect', selectTag.title)

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
