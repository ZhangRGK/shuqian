Template.bookMarkList.helpers({
  uniqTag: ->
    Session.get('uniqTag')
  isEmpty:->
    if @bookMarks
      return @bookMarks.count() == 0
    else
      return false
    
})

updateState = ->
  $('option', $('#multi')).each((element)->
    $(this).removeAttr('selected').prop('selected', false)
  )
  $('#multi').multiselect('refresh')

  if $('input[name="bookmark"]:checked').val()
    $('#multith').css({visibility: "visible"})
  else
    $('#multith').css({visibility: "hidden"})

  $('input[name="bookmark"]:checked').map(->
    bookMarkId = $(this).val()
    bookMark = getBookmark(bookMarkId)
    selectTags = Tags.find({url: bookMark.url, stat: 1}).fetch()
    for selectTag in selectTags
      $('#multi').multiselect('select', selectTag.title)
  )

Template.bookMarkList.events = {
  'click #editor': (evt, template)->
    $('input[type="checkbox"]').toggle()
    if($('#multi').prop('disabled'))
      $('#multi').multiselect('enable')
    else
      $('#multi').multiselect('disable')
  'click input[type="checkbox"]': (evt, template)->
    if $(evt.target).prop('name') == 'selectall'
      if $(evt.target).prop('checked')
        $('input[name="bookmark"]').prop('checked', true)
      else
        $('input[name="bookmark"]').prop('checked', false)
    updateState()
}
