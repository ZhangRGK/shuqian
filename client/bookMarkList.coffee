Template.bookMarkList.helpers({
  uniqTag: ->
    Session.get('uniqTag')
  bookMarks: ->
    if Session.get("shuqianType")=="explore"
      return this.bookMarks
      bookMarks = this.bookMarks.fetch()
      array = _.uniq(bookMarks, false, (d)-> return d.url)
      records = []
      i = 0
      while i < 14
        records = records.concat(array.splice(Math.round(Math.random() * array.length), 1))
        i++
      return records
    else if Session.get("shuqianType")=="blacklist"
        return this.bookMarks
    else
      return this.bookMarks
})

updateState = ->
  $('option', $('#multi')).each((element)->
    $(this).removeAttr('selected').prop('selected', false)
  )
  $('#multi').multiselect('refresh')

  $('input[name="bookmark"]:checked').map(->
    bookMarkId = $(this).val()
    bookMark = BookMarks.findOne({_id: bookMarkId})
    selectTags = Tags.find({url: bookMark.url, stat: 1}).fetch()
    for selectTag in selectTags
      $('#multi').multiselect('select', selectTag.title)
  )

  if $('input[name="bookmark"]:checked').val()
    $('#multith').css({visibility: "visible"})
  else
    $('#multith').css({visibility: "hidden"})

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
