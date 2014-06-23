Template.bookMarkList.events = {
  'click #editor':  (evt, template)->
    $('input[type="checkbox"]').toggle()
}

Template.bookMarkList.helpers({
  otherTags: ->
    if @tags
      _.reject(@tags, (d)=> d.title == @tag)
    else
      return
})
