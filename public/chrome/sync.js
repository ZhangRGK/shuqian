var userId = localStorage.getItem('userId');

var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
//var ddp = new MeteorDdp("ws://localhost:3000/websocket");

// 设定徽章背景色
chrome.browserAction.setBadgeBackgroundColor({"color": [255, 0, 0, 255]});


ddp.connect().done(function () {
    console.log("connect");

    var bookmarks = ddp.subscribe('ddp_bookmarks', [userId])
        .fail(function (error) {
            chrome.browserAction.setBadgeText({"text": "☠"});
            console.log(error);
        });

    var tags = ddp.subscribe('ddp_tags', [userId])
        .fail(function (error) {
            chrome.browserAction.setBadgeText({"text": "☠"});
            console.log(error);
        });

    var taskQueue = {
        "running": false,
        "queue": []
    };

    taskQueue.setRunning = function (running) {
        this.running = running;
    };

    taskQueue.push = function (task) {
        this.queue.push(task);
    };

    taskQueue.start = function () {
        if (taskQueue.running) {
            return;
        } else if (taskQueue.queue.length === 0) {
            chrome.browserAction.setBadgeText({"text": ""});
            setTimeout(taskQueue.start, 5000);
        } else {
            taskQueue.runTask();
        }
    };

    taskQueue.start();

    taskQueue.runTask = function () {
        chrome.browserAction.setBadgeText({"text": "↑↓"});
        taskQueue.setRunning(true);
        var task = this.queue.shift();

        if (task.type == "add") {
            //TODO 判断是否存在 tag
            //TODO 判断该tag下是否存在书签
            //TODO 新增书签
            chrome.bookmarks.search({"title": task.changedDoc.title}, function (tags) {
                findAddBookMark(task.changedDoc, ddp.getCollection("bookmarks"), function (addedBookMark) {
                    if (tags != null && tags.length > 0) {
                        for (var j in tags) {
                            var tag = tags[j];
                            chrome.bookmarks.search({"title": addedBookMark.title, "url": addedBookMark.url}, function (bookmarks) {
                                if (bookmarks != null && bookmarks.length > 0) {
                                    for (var i in bookmarks) {
                                        var bm = bookmarks[i];
                                        if (bm.parentId != tag.id) {
                                            chrome.bookmarks.create({"parentId": tag.id, "title": addedBookMark.title, "url": addedBookMark.url}, function () {
                                                taskQueue.setRunning(false);
                                                taskQueue.start();
                                            });
                                            break;
                                        } else {
                                            continue;
                                        }
                                    }
                                }
                            });
                        }
                    }
                    else {
                        chrome.bookmarks.create({"parentId": "1", "title": task.changedDoc.title, "url": null}, function (newTag) {
                            chrome.bookmarks.create({"parentId": newTag.id, "title": addedBookMark.title, "url": addedBookMark.url}, function () {
                                taskQueue.setRunning(false);
                                taskQueue.start();
                            });
                        });
                    }
                });
            });
        }
        else if (task.type == "remove") {
            //TODO 先找到目录，然后找到书签，最后一起删除掉
            chrome.bookmarks.search({"title": task.changedDoc.title}, function (tags) {
                if (tags != null && tags.length > 0) {
                    tags.forEach(function (tag) {
                        chrome.bookmarks.search({"url": task.changedDoc.url}, function (bookmarks) {
                            if (bookmarks != null && bookmarks.length > 0) {
                                bookmarks.forEach(function (bm) {
                                    if (bm.parentId == tag.id) {
                                        chrome.bookmarks.remove(bm.id, function () {
                                            taskQueue.setRunning(false);
                                            taskQueue.start();
                                        });
                                    }
                                });
                            }
                        });
                    });
                }
            });
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

//单个同步
    tags.done(function () {
        bookmarks.done(function () {
            ddp.watch('tags', function (changedDoc, message) {
                if (message === "added") {
                    taskQueue.push({"type": "add", "changedDoc": changedDoc});
                } else if (message === "removed") {
                    taskQueue.push({"type": "remove", "changedDoc": changedDoc});
                }
            });
        });
    });
})
;

//取到userId,插入localStorage
chrome.runtime.onMessage.addListener(
    function (request, sender, sendResponse) {
        localStorage.setItem('userId', request.userId);
        localStorage.setItem("userEmail", request.email);
    }
);

var serviceUrl = 'http://shuqian.bigzhu.org';
//serviceUrl = 'http://localhost:3000';
//浏览器新增bookmarks
chrome.bookmarks.onCreated.addListener(function(id,bookmark) {
    parentId = bookmark.parentId;
    bookmark.userId = userId;
    chrome.bookmarks.get(parentId, function(parenBookmarks){
        tag = parenBookmarks[0].title;
        bookmark.tag = tag;
    });

    chrome.browserAction.setBadgeText({"text": "↑↑"});
    $.post(serviceUrl+"/add",bookmark, function(data,status){
    console.log("Data: " + data + "\nStatus: " + status);
    chrome.browserAction.setBadgeText({"text": ""});
  });
});
