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
    nonSelectedText: '选择标签',
    #includeSelectAllOption: true,
    numberDisplayed: 8,
    selectedClass: null,
    templates: {
      divider: '<div class="divider" data-role="divider"></div>'
    },
    onChange: (element, checked)->
      tag = $(element).val()
      console.log(element)
      if(tag == 'addtagvalue')
        $(element).prop('selected':false)
        $('#myModal').modal('show')
        return

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

    #新建标签option
    data.push({label:'新建标签', value:'addtagvalue'})

    $('#multi').multiselect('dataprovider', data)
    $('#multi').append($('<option></option>').attr('value', '123').text('123'))

    #$('input[value="addtagvalue"]').prop('disabled',true)
    $('input[value="addtagvalue"]').hide()

    selectMulti()
  )
