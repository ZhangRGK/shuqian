signIn_Check = false

reg_emailCheck = false
reg_pwdCheck = false

Template.login.events = {
  'click #loginWithGoogle':(evt, template)->
    loading(evt.target)
    Meteor.loginWithGoogle({},  (err)->
      if (err)
        console.log err
      else
        Router.go('/common')
      finish(evt.target,"<i class='fa fa-google'></i>使用Google帐号登录")
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

  'click #currentTheme':->
    $("#currentTheme").animate({top: "-40px"},200,->
        $("#changeTheme").animate({top: "20px"},200)
    )

  'click #changeTheme li':(evt)->
    n=$("#changeTheme li").index($(evt.target))
    $("#cbp-bislideshow li").addClass('hide')
    $("#cbp-bislideshow li:eq("+n+")").removeClass('hide')
    $("#currentTheme").css("background-color",$("#changeTheme li:eq("+n+")").css("background-color"));
    $("#changeTheme").animate({top: "-20px"},200,->
        $("#currentTheme").animate({top: "20px"},200)
    )
    window.localStorage.setItem("themeNum",n)

  # login
  'keypress #signIn_email':(evt)->
    if evt.keyCode == 13
      signIn(evt)
    reg = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/
    email = $(evt.target).val()
    if !reg.test(email)
      $(evt.target).css("border-color","#a94442")
      signIn_Check = false
    else
      $(evt.target).css("border-color","#3c763d")
      signIn_Check = true
    checkSignIn()
    return

  'blur #signIn_email':(evt)->
    reg = /^(\w)+(\.\w+)*@(\w)+((\.\w{2,3}){1,3})$/
    email = $(evt.target).val()
    if email == ""
      signIn_Check = false
    else if !reg.test(email)
      $(evt.target).css("border-color","#a94442")
      signIn_Check = false
    else
      $(evt.target).css("border-color","#3c763d")
      signIn_Check = true
    checkSignIn()
    return

  'keyup #signIn_pwd':(evt)->
    if evt.target.value.length < 6
      $(evt.target).css("border-color","#a94442")
    else if evt.keyCode == 13
      if checkSignIn()
        signIn(evt)
    else
      $(evt.target).css("border-color","#3c763d")
    checkSignIn()
    return

  'click #signIn':(evt)->
    signIn(evt)

  # register
  # 请文千调整下面的颜色并且定义class
  'keyup #reg_email':(evt)->
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

  'keyup #reg_pwd':(evt)->
    if evt.target.value.length >= 6
      $("#reg_pwd").css("border-color","#3c763d")
    else
      $("#reg_pwd").css("border-color","#a94442")

  # 验证两次密码输入
  'blur #reg_repwd,#reg_pwd':(evt)->
    pwd = $("#reg_pwd").val()
    repwd = $("#reg_repwd").val()
    if pwd != repwd || repwd == ""
      $("#reg_repwd").css("border-color","#a94442")
      reg_pwdCheck = false
    else
      $("#reg_repwd").css("border-color","#3c763d")
      reg_pwdCheck = true
    checkReg()
    return

  'keyup #reg_repwd,#reg_pwd':(evt)->
    pwd = $("#reg_pwd").val()
    repwd = $("#reg_repwd").val()
    if pwd != repwd || repwd == ""
      $("#reg_repwd").css("border-color","#a94442")
      reg_pwdCheck = false
    else
      $("#reg_repwd").css("border-color","#3c763d")
      reg_pwdCheck = true
    checkReg()
    return

  'change #reg_agree':->
    checkReg()

  'click #reg':(evt)->
    loading(evt.target)
    Accounts.createUser({"email":$("#reg_email").val(),"password":$("#reg_pwd").val()},(error)->
      if error
        $("#reg_error_label").html("Email 已经存在")
        $("#reg_error").removeClass("hide")
      else
        Router.go("/")
      finish(evt.target,'注册')
    )
}

signIn = (evt)->
    loading(evt.target)
    Meteor.loginWithPassword($("#signIn_email").val(),$("#signIn_pwd").val(),(error)->
      if error
        $("#signIn_error_label").html("用户名或密码错误")
        $("#signIn_error").removeClass("hide")
      else
        Router.go("/common")
      finish(evt.target,"登录")
    )

checkSignIn = ->
  if signIn_Check and $("#signIn_pwd").val().length >= 5
    $("#signIn").removeAttr("disabled")
    return true
  return false

checkReg = ->
  if reg_emailCheck and reg_pwdCheck and $("#reg_agree").is(":checked")
    $("#reg").removeAttr("disabled")
  else
    $("#reg").attr("disabled","disabled")

loading = (target)->
  $(target).attr("disabled","disabled").html("<i class='fa fa-spinner fa-spin'></i>")

finish = (target,text)->
  $(target).removeAttr("disabled").html(text)

Template.login.rendered = ->
  n = window.localStorage.getItem("themeNum")
  if n
    $("#cbp-bislideshow li:eq("+n+")").removeClass('hide');
  else
    $("#cbp-bislideshow li:eq("+Math.floor(Math.random() * $('#changeTheme ul>li').length)+")").removeClass('hide');
