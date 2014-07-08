Template.bookMarkList.helpers({
  uniqTag: ->
    Session.get('uniqTag')
  isEmpty:->
    if @bookMarks
      return @bookMarks.count() == 0
    else
      return false
  info:->
    if window.location.pathname == "/explore"
      return '这里没有数据,是因为没有足够的用户量和网站,我们没法选出足够的好站点给你!请多帮我们宣传!'
    else
      return '没有收藏任何网站'
    
})



Template.bookMarkList.events = {
  'click #editor': (evt, template)->
    $('input[type="checkbox"]').toggle()
    if($('#multi').prop('disabled'))
      $('#multi').multiselect('enable')
    else
      $('#multi').multiselect('disable')
}
