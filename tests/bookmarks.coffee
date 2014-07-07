assert = require("assert");

suite "Bookmarks",()->
  test 'collection',(done,server)->
    server.eval ()->
      bms = BookMarks.find().fetch()
      emit("bms",bms)

    server.once("bms",(bms)->
      assert.equal(bms.length>0,true)
      done()
    )