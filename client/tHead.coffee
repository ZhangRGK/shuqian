Template.tHead.rendered = ->
  $('.multiselect').multiselect()
  Deps.autorun(->
    tags = Tags.find().fetch()
    uniqTag = _.uniq(tags, false, (d)-> return d.title)
    data = []
    for tag in uniqTag
      tag.count = Tags.find({title:tag.title}).count()
      data.push({label:tag.title, value:tag.title})
    $(".multiselect").multiselect('dataprovider', data)
  )
