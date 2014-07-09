
selectMulti = ->
  #根据选中checkbox,重新选中multiselect
  $('input[name="bookmark"]:checked').map(->
    bookMarkUrl = $(this).val()
    bookMark = getBookmarkByUrl(bookMarkUrl)
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
          bookMarkUrl = $(this).val()
          bookMark = getBookmarkByUrl(bookMarkUrl)
          bookMark.stat = 1
          addTag(bookMark, tag)
        )
      #删除
      else
        $('input[name="bookmark"]:checked').map(->
          bookMarkUrl = $(this).val()
          removeTag(bookMarkUrl, tag)
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

    optionDOM = '<option value="addtagvalue">新建标签</option>' + '<option data-role="divider"></option>'

    for tag in uniqTag
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

Template.tHead.events = {
  'keyup #search': (evt, template)->
    value = $(evt.target).val()
    if value == ''
      Router.go('/common')
    else
      Router.go('/search/' + value)
    if evt.keyCode==13
      $('.url')[0].click()
  'click .selectall': (evt, template)->
    if $(evt.target).prop('checked')
      $('input[name="bookmark"]').prop('checked', true)
    else
      $('input[name="bookmark"]').prop('checked', false)
    showMultith()
}
