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
          bookMark = BookMarks.findOne({_id:bookMarkId})
          addTag(bookMark, tag)
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
    #data = []

    currentTag = Session.get('tag')

    #for tag in uniqTag
    #  if tag.title != currentTag
    #    data.push({label:tag.title, value:tag.title})

    ##新建标签option
    #data.push({optgroup:[{label:currentTag, value:currentTag}]})
    #data.push({label:'新建标签', value:'addtagvalue'})




    optionDOM = ""
    for tag in uniqTag
      if tag.title != currentTag
        #data.push({label:tag.title, value:tag.title})
        optionDOM += '<option value="' + tag.title + '">' + tag.title + '</option>'
    optionDOM +=  '<option data-role="divider"></option>' + '<option value="' + currentTag + '">' + currentTag + '</option>' + '<option value="addtagvalue">新建标签</option>'

    $('#multi').html(optionDOM)
    $('#multi').multiselect('rebuild')

    #$('#multi').multiselect('dataprovider', data)

    #$('option', $('#multi')).each((element)->
    #  if $(this).val() == currentTag
    #    $(this).addClass('active')
    #    console.log currentTag
    #    console.log this
		#)

    #$('input[value="addtagvalue"]').prop('disabled',true)
    $('input[value="addtagvalue"]').hide()

    selectMulti()
  )
