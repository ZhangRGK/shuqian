Template.main.events = {
  'keyup #search':  (evt, template)->
    value = $(evt.target).val()
    if value == ''
      Router.go('/')
    else
      Router.go('/search/'+value)
}