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

updateState = ->
  $('option', $('#multi')).each((element)->
    $(this).removeAttr('selected').prop('selected', false)
  )
  $('#multi').multiselect('refresh')

  $('input[name="bookmark"]:checked').map(->
    bookMarkId = $(this).val()
    bookMark = BookMarks.findOne({_id:bookMarkId})
    selectTags = Tags.find({url:bookMark.url, stat:1}).fetch()
    for selectTag in selectTags
      $('#multi').multiselect('select', selectTag.title)
  )

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
        updateState()
      else
        $('input[name="bookmark"]').prop('checked', false)
        updateState()
    else
      updateState()
}
