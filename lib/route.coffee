log = (parm)-> console.log parm

Router.configure({
  layoutTemplate: 'main'
})

distinctBookmarks = (bookMarks)->
  _.uniq(bookMarks, false, (d)-> return d.url)

getBookMarksByTag = (tag)->
  tagNode = BookMarks.findOne({title:tag})
  #会调二次,要解决,很奇怪(route没有wait导致的)
  #if !tagNode
  #  return
  id = tagNode.id
  bookMarks = BookMarks.find({parentId:id}).fetch()
  distinctBookmarks(bookMarks)
getTags = ->
  tags = Tags.find().fetch()
  willPop = [tags]
  for tag in tags
    bookMark = BookMarks.findOne({title:tag.title})
    if !bookMark
      continue
    #tag.count = BookMarks.find({parentId:bookMark.id}).count()
    tag.count = distinctBookmarks(BookMarks.find({parentId:bookMark.id}).fetch()).length
    if tag.count == 0
      willPop.push(tag)
  tags = _.without.apply(this, willPop)
  tags = _.sortBy(tags, (data)-> return data.count)
  tags

getTagsById = (id)->
  #找到这个id的bookMark
  bookMark = BookMarks.findOne({_id:id})
  #找到所有相等的url的bookMark
  url = bookMark.url
  bookMarks = BookMarks.find({url:url}).fetch()
  #归属其上级节点id合集
  tagIds = []
  for bookMark in bookMarks
    tagIds.push(bookMark.parentId)
  #找到所有的tag
  BookMarks.find({id: {$in:tagIds}})

getTagsByURL = (url)->
  url = decodeURIComponent(url)
  bookMarks = BookMarks.find({url:url}).fetch()
  #归属其上级节点id合集
  tagIds = []
  for bookMark in bookMarks
    tagIds.push(bookMark.parentId)
  #找到所有的tag
  BookMarks.find({id: {$in:tagIds}})
getBookMarksBySearch = (value)->
  bookMarks = BookMarks.find({'$or' : [
    { 'url':{'$regex':value} },
    { 'title':{'$regex':value} }, ]
  }).fetch()
  return distinctBookmarks(bookMarks)

  
Router.map(->
  this.route('bookMarkList', {
    path: '/',
    waitOn: -> [Meteor.subscribe('bookmarks'), Meteor.subscribe('tags')],
    data: ->
      {
        bookMarks: BookMarks.find(),
        tags: getTags()
        #tags: Tags.find()
      }
  })

  this.route('bookMarkList', {
    path: '/search/:_value',
    waitOn: -> [Meteor.subscribe('bookmarks'), Meteor.subscribe('tags')],
    data: ->
      {
        bookMarks: getBookMarksBySearch(@params._value),
        tags: getTags()
      }
  })

  this.route('bookMarkList', {
    path: '/tag/:_tag',
    waitOn: -> [Meteor.subscribe('bookmarks'), Meteor.subscribe('tags')],
    data: ->
      {
        bookMarks: getBookMarksByTag(@params._tag),
        tags: getTags()
      }
  })

  this.route('bookMarkDetail', {
    path: '/d/:_url',
    waitOn: -> [Meteor.subscribe('bookmarks'), Meteor.subscribe('tags')],
    data: ->
      {
        bookMark: BookMarks.findOne({url:decodeURIComponent(@params._url)}),
        thisTags: getTagsByURL(@params._url),
        tags: getTags()
      }
  })
)

Meteor.Router.add('/add', 'POST', ->
  bookmark = eval(this.request.body)
  if BookMarks.find({url:bookmark.url}).count() == 0
    BookMarks.insert(bookmark)
    console.log(bookmark)
)
Meteor.Router.add('/remove', 'POST', ->
  console.log('remove')
  bookmark = eval(this.request.body)
  BookMarks.remove({index:bookmark.index})
  console.log(bookmark)
)

cook = (node)->
  temp = new node.constructor()
  isTag = false
  for key of node
    if key != 'children'
      temp[key] = node[key]
    else
      if Tags.find({title:node.title}).count() == 0 and node.title!=''
        Tags.insert({title:node.title})
      for i in node[key]
        cook(i)
  if BookMarks.find(temp).count() == 0
    BookMarks.insert(temp)

Meteor.Router.add('/upload', 'POST', ->
  console.log('upload')
  bookmark = eval(this.request.body)
  cook(bookmark[0])
)

Meteor.Router.add('/update', 'POST', ->
  console.log('update')
  bookmark = eval(this.request.body)
  log bookmark
  BookMarks.update({id:bookmark.id}, {$set:{index:bookmark.index, parentId:bookmark.parentId}})
)
