Template.disqus.rendered = ->
  if Meteor.user()
    window.disqus_config = ->
      this.page.language = 'zh'

    DISQUS?.reset(
      reload: true
      config: ->
    )

  Deps.autorun(->
    if !window.DISQUS
      disqus_shortname = 'bigmark'
      (->
        dsq = document.createElement("script")
        dsq.type = "text/javascript"
        dsq.async = true
        dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js"
        (document.getElementsByTagName("head")[0] or document.getElementsByTagName("body")[0]).appendChild dsq
        return
      )()
  )
