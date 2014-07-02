db.bookmarks.find().forEach(function (bookmark) {
    if (db.statistical.find({"url": bookmark.url}).count() == 0) {
        var tag = db.tags.findOne({"url": bookmark.url, "stat": 1});
        db.statistical.insert({"url": bookmark.url, "tags": [tag.title], "count": 0, "star": 1, "black":0});
    } else {
        var star = db.tags.find({"url": bookmark.url, "stat": 1}).count();
        var black = db.tags.find({"url": bookmark.url, "stat": 2}).count();
        var counts = db.tags.find({"url": bookmark.url, "stat": 2},{"$field":{"count":1,"_id":0}});
        var tags = db.tags.find({"url": bookmark.url, "stat": 2},{"$field":{"title":1,"_id":0}});
        var count = 0;
        for(c in counts) {
            count += c;
        }
        db.statistical.update({"url": bookmark.url}, {"$set": {"tags":tags,"star": star, "black": black, "count":count}});
    }
});

