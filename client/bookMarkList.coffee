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
  console.log('1')
  console.log($('#multi').val())
  console.log('2')
  for selectTag in selectTags
    for tag in uniqTag
      if selectTag.title == tag.title
        tag.selected = selected
        if(tag.selected)
          $('#multi').multiselect('select', selectTag.title)
        else
          $('#multi').multiselect('deselect', selectTag.title)
  Session.set('uniqTag', uniqTag)

Meteor.startup(->
  $('.multiselect').multiselect()
  console.log('xx')
)

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
