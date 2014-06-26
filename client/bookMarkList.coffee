Template.bookMarkList.helpers({
  #otherTags: ->
  #  if @tags
  #    _.reject(@tags, (d)=> d.title == @tag)
  #  else
  #    return
  uniqTag:->
    Session.get('uniqTag')
})

toggle = (tar, selected)->
  id = tar.val()
  bookMark = BookMarks.findOne({_id:id})
  selectTags = Tags.find({url:bookMark.url, stat:1}).fetch()

  tags = Tags.find({stat:1}).fetch()
  uniqTag = _.uniq(tags, false, (d)-> return d.title)


  for selectTag in selectTags
    for tag in uniqTag
      if selectTag.title == tag.title
        tag.selected = selected
        if(tag.selected)
          $('#multi').multiselect('select', selectTag.title)
        else
          $('#multi').multiselect('deselect', selectTag.title)

  if($('#multi').val() == null)
    $('#multi').multiselect('disable')
  else
    $('#multi').multiselect('enable')

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
        $('input[name="bookmark"]').prop('checked', true)
        toggle($('input[name="bookmark"]'),true)
      else
        $('input[name="bookmark"]').prop('checked', false)
        toggle($('input[name="bookmark"]'),false)
    else
      if $(evt.target).prop('checked')
        toggle($(evt.target), true)
      else
        toggle($(evt.target), false)
}
