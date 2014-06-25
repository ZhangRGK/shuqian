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
    if($('#multi').prop('disabled'))
      $('#multi').multiselect('enable')
    else
      $('#multi').multiselect('disable')
  ,

  'click input[type="checkbox"]':  (evt, template)->
    if $(evt.target).prop('name') == 'selectall'
     if $(evt.target).prop('checked')
        $('input[name="bookmark"]').prop("checked", true)
      else
        $('input[name="bookmark"]').prop("checked", false)
    else
      if $(evt.target).prop('checked')
        toggle(evt, true)
      else
        toggle(evt, false)
}
