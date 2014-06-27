Template.bookMarkList.helpers({
  #otherTags: ->
  #  if @tags
  #    _.reject(@tags, (d)=> d.title == @tag)
  #  else
  #    return
  uniqTag:->
    Session.get('uniqTag')
})

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
    #$('#multi').multiselect('disable')
    $('#multith').hide()
  else
    $('#multith').show()
#$('#multi').multiselect('enable')

Template.bookMarkList.events = {
  'click #editor':  (evt, template)->
    $('input[type="checkbox"]').toggle()
    if($('#multi').prop('disabled'))
      $('#multi').multiselect('enable')
    else
      $('#multi').multiselect('disable')
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
