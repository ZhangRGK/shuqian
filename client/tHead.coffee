addTag = (bookMarkId, tag)->
  bookMark = BookMarks.findOne({_id:bookMarkId})

  tag = {userId:Meteor.userId(), url:bookMark.url, title:tag, stat:1}
  if Tags.find(tag).count() == 0
    Tags.insert(tag)

removeTag = (bookMarkId, tag)->
  bookMark = BookMarks.findOne({_id:bookMarkId})
  tag = {userId:Meteor.userId(), url:bookMark.url, title:tag, stat:1}
  doTag = Tags.findOne(tag)
  Tags.update({_id:doTag._id}, {$set: {stat:0}})

selectMulti = ->
  $('input[name="bookmark"]:checked').map(->
    bookMarkId = $(this).val()
    bookMark = BookMarks.findOne({_id:bookMarkId})
    selectTags = Tags.find({url:bookMark.url}).fetch()

    for selectTag in selectTags
      $('#multi').multiselect('select', selectTag.title)
  )

Template.tHead.rendered = ->
  $('#multi').multiselect({
    #includeSelectAllOption: true,
    numberDisplayed: 8,
    onChange: (element, checked)->
      tag = $(element).val()
      #增加
      if checked
        $('input[name="bookmark"]:checked').map(->
          bookMarkId = $(this).val()
          addTag(bookMarkId, tag)
        )
      #删除
      else
        $('input[name="bookmark"]:checked').map(->
          bookMarkId = $(this).val()
          removeTag(bookMarkId, tag)
        )
  })

  Deps.autorun(->
    tags = Tags.find().fetch()
    uniqTag = _.uniq(tags, false, (d)-> return d.title)
    data = []
    for tag in uniqTag
      tag.count = Tags.find({title:tag.title}).count()
      data.push({label:tag.title, value:tag.title})
    $('#multi').multiselect('dataprovider', data)
    selectMulti()
  )
