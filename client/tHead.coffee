addTag = (bookMarkId, tag)->
  bookMark = BookMarks.findOne({_id:bookMarkId})

  tag = {userId:Meteor.userId(), url:bookMark.url, title:tag}
  findTag = Tags.findOne(tag)
  console.log findTag
  if findTag
    Tags.update({_id:findTag._id}, {$set: {stat:1}})
  else
    tag.stat=1
    Tags.insert(tag)

removeTag = (bookMarkId, tag)->
  bookMark = BookMarks.findOne({_id:bookMarkId})
  tag = {userId:Meteor.userId(), url:bookMark.url, title:tag, stat:1}
  doTag = Tags.findOne(tag)
  Tags.update({_id:doTag._id}, {$set: {stat:0}})
  #Tags.remove({_id:doTag._id})

selectMulti = ->
  #根据选中checkbox,重新选中multiselect
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

  #preTagsList = []
  Deps.autorun(->
    tags = Tags.find({stat:1}).fetch()
    uniqTag = _.uniq(tags, false, (d)-> return d.title)
    data = []
    for tag in uniqTag
      tag.count = Tags.find({title:tag.title}).count()
      data.push({label:tag.title, value:tag.title})
      #tagList.push(tag.title)

    #新建标签option
    data.push({label:'新建标签', value:'addtagvalue'})


    #if _.difference(tagList, preTagsList).length != 0
    $('#multi').multiselect('dataprovider', data)
    #  preTagsList = tagList
    $('#multi').append($('<option></option>').attr('value', '123').text('123'))

    #$('input[value="addtagvalue"]').prop('disabled',true)
    $('input[value="addtagvalue"]').hide()

    console.log tags
    selectMulti()
  )
