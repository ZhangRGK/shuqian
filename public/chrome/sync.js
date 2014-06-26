var userId = localStorage.getItem('userId');

var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
//var ddp = new MeteorDdp("ws://localhost:3000/websocket");

chrome.browserAction.setBadgeBackgroundColor({"color": [255, 0, 0, 255]});

ddp.connect().done(function () {
    console.log("connect");

    var bookmarksTree = null;

    var bookmarks = ddp.subscribe('ddp_bookmarks', [userId])
        .fail(function (error) {
            chrome.browserAction.setBadgeText({"text": "!"});
            console.log(error);
        });

    var tags = ddp.subscribe('ddp_tags', [userId])
        .fail(function (error) {
            chrome.browserAction.setBadgeText({"text": "!"});
            console.log(error);
        });

    var counter = 0;
    var counterPlus = function () {
        counter += 1;
        checkCounter();
    };

    var counterMinus = function () {
        counter -= 1;
        checkCounter();
    };

    var checkCounter = function () {
        console.log(counter);
        if (counter > 0) {
            chrome.browserAction.setBadgeText({"text": "+" + counter});
        } else if (counter == 0) {
            chrome.browserAction.setBadgeText({"text": ""});
        } else {
            chrome.browserAction.setBadgeText({"text": "" + counter});
        }
    };

    var findRemoveBookMark = function (tag, parent, tree, callback) {
        for (var i in tree) {
            var node = tree[i];
            if (node.url == tag.url && parent == tag.title) {
                callback(node);
            } else if (node.children) {
                findRemoveBookMark(tag, node.title, node.children, callback);
            }
        }
    };

    var findAddBookMark = function (tag, tree, callback) {
        for (var i in tree) {
            var node = tree[i];
            if (node.url == tag.url) {
                callback(node);
            }
        }
    };

    var findTagByTitle = function (title, tree, callback) {
        var tags = [];
        var searchTags = function (title, tree) {
            for (var i in tree) {
                var node = tree[i];
                if (node.title == title && (node.url == null || node.url == "")) {
                    tags.push(node);
                } else if (node.children) {
                    searchTags(title, node.children);
                } else {
                    tags.push("null");
                }
            }
        };

        searchTags(title, tree);
        for (var i in tags) {
            if (tags[i] != "null") {
                callback(tags[i]);
                return;
            }
        }
        callback("null");
    };


    //单个同步
    tags.done(function () {
        bookmarks.done(function () {
            ddp.watch('tags', function (changedDoc, message) {
                console.log(changedDoc, message);
                if (message === "removed") {
                    chrome.bookmarks.getTree(function (BookmarkTreeNode) {
//                        console.log("getTree", bookmarkTreeNodes);
                        counterMinus();
                        findRemoveBookMark(changedDoc, null, BookmarkTreeNode, function (changedBookmark) {
//                            console.log(changedDoc, changedBookmark);
                            chrome.bookmarks.remove(changedBookmark.id);
                            setTimeout(counterPlus, 1000);
                        });
                    });
                } else if (message === "added") {
                    counterPlus();
//                    console.log(ddp.getCollection("bookmarks"));
                    findAddBookMark(changedDoc, ddp.getCollection("bookmarks"), function (addedBookmark) {
//                        console.log(addedBookmark);
                        chrome.bookmarks.getTree(function (BookmarkTreeNode) {
                            findTagByTitle(changedDoc.title, BookmarkTreeNode, function (tag) {
                                if (tag == "null") {
                                    chrome.bookmarks.create({"parentId": "1", "title": changedDoc.title, "url": null}, function (newTag) {
                                        chrome.bookmarks.create({"parentId": newTag.id, "title": addedBookmark.title, "url": addedBookmark.url}, function (bookmark) {
                                            setTimeout(counterMinus, 1000);
                                        });
                                    });
                                } else {
                                    chrome.bookmarks.create({"parentId": tag.id, "title": addedBookmark.title, "url": addedBookmark.url}, function (bookmark) {
                                        setTimeout(counterMinus, 1000);
                                    });
                                }
                            });
                        });
                    });
                }
            });
        });
    });

});

//取到userId,插入localStorage
chrome.runtime.onMessage.addListener(
    function (request, sender, sendResponse) {
        localStorage.setItem('userId', request.userId);
        localStorage.setItem("userEmail", request.email);
    }
);
