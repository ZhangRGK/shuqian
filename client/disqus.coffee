Template.disqus.rendered = ->
  Session.set("loadDisqus", true)
  disqusSignon = Session.get("disqusSignon")
  if Meteor.user() and disqusSignon
    window.disqus_config = ->
      this.page.language = 'zh'

    DISQUS?.reset(
      reload: true
      config: ->
    )
