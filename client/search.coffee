Template.search.events = {
  'keyup #search': (evt, template)->
    value = $(evt.target).val()
    if value == ''
      Router.go('/common')
    else
      Router.go('/search/' + value)
    if evt.keyCode==13
      $('.url')[0].click()
}
