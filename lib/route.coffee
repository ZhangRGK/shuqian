log = (parm)->
  console.log parm

Router.configure({
  waitOn: -> [Meteor.subscribe('bookmarks'), Meteor.subscribe('tags'), Meteor.subscribe('explores')],
  layoutTemplate: 'main',
  loadingTemplate: 'loading'
})

distinctBookmarks = (bookMarks)->
  _.uniq(bookMarks, false, (d)-> return d.url)

getBookMarksByTag = (tag)->
  Session.set('shuqianTag', tag)
  Session.set('shuqianType', null)
  tags = Tags.find({title:tag, stat:1}).fetch()
  urls = _.pluck(tags, 'url')
  BookMarks.find({url: {$in: urls}}, {sort:{dateAdded:-1}})

getTags = ->
  tags = Tags.find({stat:1}).fetch()
  uniqTag = _.uniq(tags, false, (d)-> return d.title)
  for tag in uniqTag
    tag.count = Tags.find({title:tag.title, stat:1}).count()
  return _.sortBy(uniqTag, (d)->  return d.title )

getTagsById = (id)->
  #找到这个id的bookMark
  bookMark = BookMarks.findOne({_id: id})
  #找到所有相等的url的bookMark
  url = bookMark.url
  bookMarks = BookMarks.find({url: url}).fetch()
  #归属其上级节点id合集
  tagIds = []
  for bookMark in bookMarks
    tagIds.push(bookMark.parentId)
  #找到所有的tag
  BookMarks.find({id: {$in: tagIds}})

getTagsByURL = (url)->
  url = decodeURIComponent(url)
  bookMarks = BookMarks.find({url: url}).fetch()
  #归属其上级节点id合集
  tagIds = []
  for bookMark in bookMarks
    tagIds.push(bookMark.parentId)
  #找到所有的tag
  BookMarks.find({id: {$in: tagIds}})
getBookMarksBySearch = (value)->
  bookMarks = BookMarks.find({'$or': [
    { 'url': {'$regex': value} },
    { 'title': {'$regex': value} },
  ]
  }).fetch()
  return distinctBookmarks(bookMarks)

#回收站
getGarbageBookMarks=->
  Session.set('shuqianTag', null)
  Session.set('shuqianType', 'garbage')
  tags = Tags.find({stat:1}).fetch()
  urls = _.pluck(tags, 'url')
  BookMarks.find({url: {$nin: urls},stat:1},{sort:{dateAdded:-1}})

#黑名单
getBlacklistBookMarks=->
  Session.set('shuqianTag', null)
  Session.set('shuqianType', 'blacklist')
#  tags = Tags.find().fetch()
#  urls = _.pluck(tags, 'url')
  BookMarks.find({stat:2},{sort:{dateAdded:-1}}).fetch()

#探索
getNotMyBookMarks=->
  Session.set('shuqianTag', null)
  Session.set('shuqianType', 'explore')
  tags = Tags.find({userId:Meteor.userId()}).fetch()
  bms = _.pluck(BookMarks.find({"userId":Meteor.userId(),"stat":2}).fetch(),"url")
  urls = _.pluck(tags, 'url').concat(bms)
  Explores.find({url: {$nin: urls}, stat:1}, {sort:{count:-1}, limit : 200})

#根目录书签
getMyBookMarks=->
  Session.set('shuqianTag', null)
  Session.set('shuqianType', null)
  tags = Tags.find({stat:1}).fetch()
  urls = _.pluck(tags, 'url')
  BookMarks.find({url: {$in: urls}, stat:1}, {sort:{count:-1}, limit : 14})

getDetailBookMark=(url)->
  BookMarks.findOne({url: url})

Router.map(->
  this.route('bookMarkList', {
    path: '/',
    data: ->
      {
      bookMarks: getMyBookMarks(),
      tags: getTags()
      }
  })
  this.route('bookMarkList', {
    path: '/explore',
    data: ->
      {
      bookMarks: getNotMyBookMarks(),
      tags: getTags()
      }
  })
  this.route('bookMarkList', {
    path: '/garbage',
    data: ->
      {
      bookMarks: getGarbageBookMarks(),
      tags: getTags()
      }
  })
  this.route('bookMarkList', {
    path: '/blacklist',
    data: ->
      {
      bookMarks: getBlacklistBookMarks(),
      tags: getTags()
      }
  })
  this.route('bookMarkList', {
    path: '/search/:_value',
    data: ->
      {
      bookMarks: getBookMarksBySearch(@params._value),
      tags: getTags()
      }
  })
  this.route('bookMarkList', {
    path: '/tag/:_tag',
    data: ->
      {
      bookMarks: getBookMarksByTag(@params._tag),
      tags: getTags(),
      tag: @params._tag
      }
    onAfterAction: ->
      $('input[name="selectall"]').prop("checked", false)
      $('input[name="bookmark"]').prop("checked", false)
      $('option', $('#multi')).each((element)->
        $(this).removeAttr('selected').prop('selected', false)
			)
      #$('#multi').multiselect('disable')
      $('#multi').multiselect('refresh')

  })

  this.route('bookMarkDetail', {
    path: '/d/:_url',
    waitOn: ->
      [Meteor.subscribe('find_tags_by_url',decodeURIComponent(@params._url)),Meteor.subscribe("find_bookmarks_by_url",decodeURIComponent(@params._url))]
    ,
    data: ->
      {
      bookMark: getDetailBookMark(decodeURIComponent(@params._url)),
      tags: ()->
        if Meteor.userId()
          return _.uniq(Tags.find({"userId":Meteor.userId(),"url":this.bookMark.url}).fetch(),false,(d)->d.title)
        else
          return _.uniq(Tags.find({"url":this.bookMark.url}).fetch(),false,(d)->d.title)
      }
  })
)

Meteor.Router.add('/add', 'POST', ->
  bookmark = eval(this.request.body)
  tag = bookmark.tag
  userId = bookmark.userId
  addTag(bookmark, tag, userId)
  return '0'
)

Meteor.Router.add('/upload', 'POST', ->
  body = eval(this.request.body)
  userId = body.userId

  nodes = []
  spread(body.data[0], nodes)
  for node in nodes
    if node.url
      bookMark = {userId:userId, url:node.url, title:node.title, dateAdded:parseInt(node.dateAdded), stat:1}
      #增加时间和状态不能纳入排重.会导致重复导入
      findBookMark = {userId:userId, url:node.url, title:node.title}
      if BookMarks.find(findBookMark).count() == 0
        BookMarks.insert(bookMark)
      if node.parentId
        parentNodes = _.filter(nodes, (d)-> return  d.id==node.parentId )
        for parentNode in parentNodes
          #增加时间和状态不能纳入排重.会导致重复导入
          tag = {userId:userId, url:node.url, title:parentNode.title, dateAdded:parseInt(parentNode.dateAdded), stat:1}
          findTag = {userId:userId, url:node.url, title:parentNode.title}
          if Tags.find(findTag).count() == 0
            Tags.insert(tag)
  return [200,'0']
)

Meteor.Router.add('/update','POST',->
  updateData = eval(this.request.body)
  console.log(updateData)
  bookmark = updateData.data
  BookMarks.update({id: bookmark.id},{$set: {index: bookmark.index, parentId: bookmark.pa}})
)

Router.onBeforeAction('loading')
