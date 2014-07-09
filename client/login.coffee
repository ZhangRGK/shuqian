signIn_Check = false

reg_emailCheck = false
reg_pwdCheck = false

Template.login.events = {
  'click #loginWithGoogle':(evt, template)->
    Meteor.loginWithGoogle({},  (err)->
      if (err)
        console.log err
      else
        Router.go('/common')
    )

  #animate
  'click #openLogin':->
    $("#welcome").fadeOut(300)
    $("#login").show().addClass("loginAnimation")

  'click #toReg':->
    $("#reg_pad").show()
    $("#login_pad").removeClass("open3D")
    $("#reg_pad").removeClass("close3D")
    $("#login_pad").addClass("close3D")
    $("#reg_pad").addClass("open3D")

  'click #toLogin':->
    $("#login_pad").removeClass("close3D")
    $("#reg_pad").removeClass("open3D")
    $("#login_pad").addClass("open3D")
    $("#reg_pad").addClass("close3D")

  'click #changeTheme li':->
    n=$("#changeTheme li").index($(this))
    $("#cbp-bislideshow li").addClass('hide')
    $("#cbp-bislideshow li:eq("+n+")").removeClass('hide')

  # login
  'keypress #signIn_email':(evt)->
    if evt.keyCode == 13
      signIn()
    reg = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/
    email = $(evt.target).val()
    if !reg.test(email)
      $(evt.target).css("border-color","#a94442")
      signIn_Check = false
    else
      $(evt.target).css("border-color","#3c763d")
      signIn_Check = true
    return

  'blur #signIn_email':(evt)->
    if evt.keyCode == 13
      signIn()
    reg = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/
    email = $(evt.target).val()
    if !reg.test(email)
      $(evt.target).css("border-color","#a94442")
      signIn_Check = false
    else
      $(evt.target).css("border-color","#3c763d")
      signIn_Check = true
    return

  'keypress #signIn_pwd':(evt)->
    if evt.keyCode == 13
      signIn()

  'click #signIn':->
    signIn()

  # register
  # 请文千调整下面的颜色并且定义class
  #TODO 验证email符合正则表达式
  'keypress #reg_email':(evt)->
    reg = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/
    email = $(evt.target).val()
    if !reg.test(email)
      $(evt.target).css("border-color","#a94442")
      reg_emailCheck = false
    else
      $(evt.target).css("border-color","#3c763d")
      reg_emailCheck = true
    checkReg()
    return

  'blur #reg_email':(evt)->
    reg = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/
    email = $(evt.target).val()
    if !reg.test(email)
      $(evt.target).css("border-color","#a94442")
      reg_emailCheck = false
    else
      $(evt.target).css("border-color","#3c763d")
      reg_emailCheck = true
    checkReg()
    return

  #TODO 验证两次密码输入
  'blur #reg_repwd,#reg_pwd':(evt)->
    if evt.target.value.length < 6
      $(evt.target).css("border-color","#a94442")
      reg_pwdCheck = false
      return
    pwd = $("#reg_pwd").val()
    repwd = $("#reg_repwd").val()
    console.log(pwd,repwd)
    if pwd != repwd
      $(evt.target).css("border-color","#a94442")
      reg_pwdCheck = false
    else
      $("#reg_pwd").css("border-color","#3c763d")
      $("#reg_repwd").css("border-color","#3c763d")
      reg_pwdCheck = true
    checkReg()
    return

  'change #reg_agree':->
    checkReg()

  'click #reg':->
    Accounts.createUser({"email":$("#reg_email").val(),"password":$("#reg_pwd").val()},(error)->
      if error
        console.log error
      else
        Router.go("/")
    )
}

signIn = ->
  if signIn_Check and $("#signIn_pwd").val().length >= 6
    Meteor.loginWithPassword($("#signIn_email").val(),$("#signIn_pwd").val(),(error)->
      if error
        console.log error
      else
        Router.go("/common")
    )

checkReg = ->
  if reg_emailCheck and reg_pwdCheck and $("#reg_agree").is(":checked")
    $("#reg").removeAttr("disabled")
  else
    $("#reg").attr("disabled","disabled")

#$("#cbp-bislideshow li:eq("+Math.floor(Math.random() * $('#changeTheme ul>li').length)+")").removeClass('hide');
