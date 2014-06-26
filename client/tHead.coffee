@addTag = (bookMarkId, tag)->
  bookMark = BookMarks.findOne({_id:bookMarkId})

  #查找是否是在其他用户的bookmark上加tag,如果是,copy到自已的上面来.
  findBookMark = {userId:Meteor.userId(), url:bookMark.url, title:bookMark.title}
  if BookMarks.find(findBookMark).count() == 0
    insertBookMark = {userId:Meteor.userId(), url:bookMark.url, title:bookMark.title, dateAdded:Date.parse(new Date())}
    BookMarks.insert(insertBookMark)

  tag = {userId:Meteor.userId(), url:bookMark.url, title:tag}
  findTag = Tags.findOne(tag)
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

selectMulti = ->
  #根据选中checkbox,重新选中multiselect
  $('input[name="bookmark"]:checked').map(->
    bookMarkId = $(this).val()
    bookMark = BookMarks.findOne({_id:bookMarkId})
    selectTags = Tags.find({url:bookMark.url, stat:1}).fetch()
    for selectTag in selectTags
      $('#multi').multiselect('select', selectTag.title)
  )

Template.tHead.rendered = ->
  $('#multi').multiselect({
    nonSelectedText: '选择标签',
    #includeSelectAllOption: true,
    numberDisplayed: 8,
    #selectedClass: null,
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

    currentTag = Session.get('tag')

    for tag in uniqTag
      if tag.title != currentTag
        data.push({label:tag.title, value:tag.title})

    #新建标签option
    data.push({label:currentTag, value:currentTag})
    data.push({label:'新建标签', value:'addtagvalue'})


    #if _.difference(tagList, preTagsList).length != 0
    $('#multi').multiselect('dataprovider', data)
    $('option', $('#multi')).each((element)->
      if $(this).val() == currentTag
        $(this).addClass('active')
        console.log currentTag
        console.log this
		)

    #$('input[value="addtagvalue"]').prop('disabled',true)
    $('input[value="addtagvalue"]').hide()

    selectMulti()
  )
