Template.main.events = {
  'keyup input':  (evt, template)->
    value = $(evt.target).val()
    console.log(value)
    if value == ''
      Router.go('/')
    else
      Router.go('/search/'+value)
}
