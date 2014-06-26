var userId = localStorage.getItem('userId');

//var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
var ddp = new MeteorDdp("ws://localhost:3000/websocket");

chrome.browserAction.setBadgeBackgroundColor({"color": [255, 0, 0, 255]});

ddp.connect().done(function () {
    console.log("connect");

    var bookmarksTree = null;
    chrome.bookmarks.getTree(function (bookmarkTreeNodes) {
        bookmarksTree = bookmarkTreeNodes;
    });

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
            chrome.browserAction.setBadgeText({"text": "+"+counter});
        } else if (counter == 0) {
            chrome.browserAction.setBadgeText({"text": ""});
        } else {
            chrome.browserAction.setBadgeText({"text": ""+counter});
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
        for (var i in tree) {
            var node = tree[i];
            if (node.title == title && (node.url == null || node.url == "")) {
                callback(node);
            } else if (node.children) {
                findTagByTitle(title, node.children, callback);
            }
        }
    };

    //单个同步
    tags.done(function () {
        bookmarks.done(function () {
            ddp.watch('tags', function (changedDoc, message) {

                console.log(changedDoc, message);
                if (message === "removed") {
                    chrome.bookmarks.getTree(function (bookmarkTreeNodes) {
                        bookmarksTree = bookmarkTreeNodes;
                        console.log("getTree", bookmarkTreeNodes);

                        counterMinus();
                        findRemoveBookMark(changedDoc, null, bookmarksTree, function (changedBookmark) {
                            console.log(changedDoc, changedBookmark);
                            chrome.bookmarks.remove(changedBookmark.id);
                            setTimeout(counterPlus,1000);
                        });
                    });
                } else if (message === "added") {
                    counterPlus();
                    console.log(ddp.getCollection("bookmarks"));
                    findAddBookMark(changedDoc, ddp.getCollection("bookmarks"), function (addedBookmark) {
                        console.log(addedBookmark);
                        findTagByTitle(changedDoc.title, bookmarksTree, function (tag) {
                            console.log(tag);
                            chrome.bookmarks.create({"parentId": tag.id, "title": addedBookmark.title, "url": addedBookmark.url}, function (bookmark) {
                                console.log(bookmark);
                                setTimeout(counterMinus,1000);
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
