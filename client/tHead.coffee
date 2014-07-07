
selectMulti = ->
  #根据选中checkbox,重新选中multiselect
  $('input[name="bookmark"]:checked').map(->
    bookMarkId = $(this).val()
    bookMark = getBookmark(bookMarkId)
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
        setTimeout(->
          $('#tagname')[0].focus()
        ,200)
        return

      #增加
      if checked
        $('input[name="bookmark"]:checked').map(->
          bookMarkId = $(this).val()
          bookMark = getBookmark(bookMarkId)
          bookMark.stat = 1
          addTag(bookMark, tag)
        )
      #删除
      else
        $('input[name="bookmark"]:checked').map(->
          bookMarkId = $(this).val()
          removeTag(bookMarkId, tag)
        )

    #取消选中的
    onDropdownHide:->
      $('input[name="bookmark"]:checked').map(->
        #新建标签modal显示时,不能取消选中的checkbox
        if $('#myModal').attr('class') != 'modal fade in'
          if $(this).is(':checked')
            $(this).click()
      )
  })

  Deps.autorun(->
    #$('#multi').hide()
    tags = Tags.find({stat:1}).fetch()
    uniqTag = _.uniq(tags, false, (d)-> return d.title)

    currentTag = Session.get('shuqianTag')
    currentType = Session.get('shuqianType')

    optionDOM = ''

    #回收站就没有当前标签
    if(currentType == 'garbage' || currentType == 'blacklist' || currentType == 'explore')
      optionDOM += '<option value="addtagvalue">新建标签</option>' + '<option data-role="divider"></option>'

    else
      #如果没有当前标签，添加null判断
      if !currentTag
        optionDOM += '<option value="addtagvalue">新建标签</option>' + '<option data-role="divider"></option>'
      else
        optionDOM += '<option value="addtagvalue">新建标签</option>' + '<option value="' + currentTag + '">' + currentTag + '</option>' +  '<option data-role="divider"></option>'


    for tag in uniqTag
      if tag.title != currentTag
        #data.push({label:tag.title, value:tag.title})
        optionDOM += '<option value="' + tag.title + '">' + tag.title + '</option>'

    $('#multi').html(optionDOM)
    $('#multi').multiselect('rebuild')

    #$('#multith').hide()

    #$('input[value="addtagvalue"]').prop('disabled',true)
    $('input[value="addtagvalue"]').hide()

    selectMulti()
  )


Template.tHead.helpers({
  isExplore:->
    window.location.pathname == "/explore"
  isBlacklist: ->
    window.location.pathname == "/blacklist"
})
