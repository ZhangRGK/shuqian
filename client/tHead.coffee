Template.tHead.rendered = ->
  $('.multiselect').multiselect()
  console.log Template.bookMarkList
  uniqTag = _.uniq(tags, false, (d)-> return d.title)
  console.log uniqTag
  data = []
  for tag in uniqTag
    tag.count = Tags.find({title:tag.title}).count()
    data.push({label:tag.title, value:tag.title})
  $(".multiselect").multiselect('dataprovider', data)
