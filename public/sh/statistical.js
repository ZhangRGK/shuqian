var distinct = function(array) {
    var distinctArray = []
    for(var i in array) {
        var el = array[i];
        if(distinctArray.indexOf(el)<0) {
            distinctArray.push(el);
        }
    }
    return distinctArray;
};

db.bookmarks.find().forEach(function (bookmark) {
    if (db.statistical.count({"url": bookmark.url}) == 0) {
        var tag = db.tags.findOne({"url": bookmark.url, "stat": 1});
        if(tag == null) {
            tag = {"title":null}
        }
        db.statistical.insert({"url": bookmark.url, "tags": [tag.title], "count": 0, "star": 1, "black": 0});
    } else {
        var star = db.tags.count({"url": bookmark.url, "stat": 1});
        var black = db.tags.count({"url": bookmark.url, "stat": 2});
        var counts = db.bookmarks.find({"url": bookmark.url, "stat": 1}).map(function (u) {
            return parseInt(u.count) ? parseInt(u.count) : 0
        });
        var tags = db.tags.find({"url": bookmark.url, "stat": 1}).map(function (u) {
            return u.title
        });
        printjson(bookmark.url);
        printjson(tags);
        tags = distinct(tags);
        var count = 0;
        for (var c in counts) {
            count += counts[c];
        }
        db.statistical.update({"url": bookmark.url}, {"$set": {"tags": tags, "star": star, "black": black, "count": count}});
    }
});
