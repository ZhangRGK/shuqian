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
      return '每天探索太多可不太好哦!每个网站值得好好品玩.请明儿赶早(或者无耻的刷新)'
    else
      return '没有数据了!这是怎么回事!'
    
})



Template.bookMarkList.events = {
  'click #editor': (evt, template)->
    $('input[type="checkbox"]').toggle()
    if($('#multi').prop('disabled'))
      $('#multi').multiselect('enable')
    else
      $('#multi').multiselect('disable')
}
