log = (parm)->
  console.log parm

Router.configure({
  layoutTemplate: 'main',
  loadingTemplate: 'loading',
  waitOn: -> [Meteor.subscribe('bookmarks'), Meteor.subscribe('tags')]
 
})

distinctBookmarks = (bookMarks)->
  _.uniq(bookMarks, false, (d)-> return d.url)

getBookMarksByTag = (tag)->
  Session.set('tag', tag)
  tags = Tags.find({title:tag}).fetch()
  urls = _.pluck(tags, 'url')
  BookMarks.find({url: {$in: urls}})

getTags = ->
  tags = Tags.find().fetch()
  uniqTag = _.uniq(tags, false, (d)-> return d.title)
  for tag in uniqTag
    tag.count = Tags.find({title:tag.title}).count()
  #Session.setDefault('uniqTag', uniqTag)
  Session.set('uniqTag', uniqTag)
  #localStorage.setItem("tags", uniqTag)
  return uniqTag

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


Router.map(->
  this.route('bookMarkList', {
    path: '/',
    data: ->
      {
      bookMarks: BookMarks.find(),
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
<<<<<<< HEAD
    onAfterAction:->
      #if Meteor.isClient
        #if typeof $('#multi').val() != 'null'
          #$('#multi').multiselect('refresh')
=======
>>>>>>> FETCH_HEAD
  })

  this.route('bookMarkDetail', {
    path: '/d/:_url',
    data: ->
      {
      bookMark: BookMarks.findOne({url: decodeURIComponent(@params._url)}),
      #thisTags: getTagsByURL(@params._url),
      thisTags: Tags.find({url: decodeURIComponent(@params._url)}),
      tags: getTags()
      }
  })
)

Meteor.Router.add('/add', 'POST', ->
  addData = eval(this.request.body)
  userId = addData.userId
  if BookMarks.find({url: addData.url, userId:userId}).count() == 0
    bookMark = {userId:userId, url:bookmark.url, title:bookmark.title, dateAdded:bookmark.dateAdded, stat:1}
    BookMarks.insert(bookmark)
)
#Meteor.Router.add('/remove', 'POST', ->
#  console.log('remove')
#  removeData = eval(this.request.body)
#  console.log(removeData)
#  userId = removeData.userId
#  BookMarks.remove({index: bookmark.index})
#  console.log(bookmark)
#)
spread = (node, nodes)->
  temp = new node.constructor()
  for key of node
    if key != 'children'
      temp[key] = node[key]
    else
      for i in node[key]
        spread(i, nodes)
  nodes.push(temp)

Meteor.Router.add('/upload', 'POST', ->
  body = eval(this.request.body)
  userId = body.userId

  nodes = []
  spread(body.data[0], nodes)

  for node in nodes
    if node.url
      bookMark = {userId:userId, url:node.url, title:node.title, dateAdded:node.dateAdded, stat:1}
      #增加时间和状态不能纳入排重.会导致重复导入
      findBookMark = {userId:userId, url:node.url, title:node.title}
      if BookMarks.find(findBookMark).count() == 0
        BookMarks.insert(bookMark)
      if node.parentId
        parentNodes = _.filter(nodes, (d)-> return  d.id==node.parentId )
        for parentNode in parentNodes
          #增加时间和状态不能纳入排重.会导致重复导入
          tag = {userId:userId, url:node.url, title:parentNode.title, dateAdded:parentNode.dateAdded, stat:1}
          findTag = {userId:userId, url:node.url, title:parentNode.title}
          if Tags.find(findTag).count() == 0
            Tags.insert(tag)
  return
)

Meteor.Router.add('/update', 'POST', ->
  console.log('update')
  bookmark = eval(this.request.body)
  log bookmark
  BookMarks.update({id: bookmark.id}, {$set: {index: bookmark.index, parentId: bookmark.parentId}})
)
