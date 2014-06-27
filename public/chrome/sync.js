var userId = localStorage.getItem('userId');

var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
//var ddp = new MeteorDdp("ws://localhost:3000/websocket");

// 设定徽章背景色
chrome.browserAction.setBadgeBackgroundColor({"color": [255, 0, 0, 255]});


ddp.connect().done(function () {
    console.log("connect");

    var search = function(queryObj,callback) {
        chrome.bookmarks.getTree(function(bmTree) {
            var array = [];
            var find = function(queryObj,tree) {
                for(var i in tree) {
                    var node = tree[i];
                    if(!!queryObj.title && !!queryObj.url) {
                        if(queryObj.title == node.title && queryObj.url == node.url) {
                            console.log("push both:",node);
                            array.push({"id":node.id,"url":node.url,"title":node.title,"parentId":node.parentId});
                        }
                    } else if (!!queryObj.title) {
                        if(queryObj.title == node.title) {
                            console.log("push title:",node);
                            array.push({"id":node.id,"url":node.url,"title":node.title,"parentId":node.parentId});
                        }
                    } else if (!!queryObj.url) {
                        if(queryObj.url == node.url) {
                            console.log("push url:",node);
                            array.push({"id":node.id,"url":node.url,"title":node.title,"parentId":node.parentId});
                        }
                    }
                    if(node.children) {
                        find(queryObj,node.children);
                    }
                }
            };
            find(queryObj,bmTree);
            callback(array);
        });
    };


//
//    search({"title":"书签栏"},function(array) {
//        console.log(array);
//    });

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
        console.log("push task:", task);
        this.queue.push(task);
        console.log("queue now:", task);
    };

    taskQueue.start = function () {
        if (taskQueue.running) {
            return;
        } else if (taskQueue.queue.length === 0) {
            chrome.browserAction.setBadgeText({"text": ""});
            setTimeout(taskQueue.start, 1000);                  //空闲时间
        } else {
            taskQueue.runTask();
        }
    };

    taskQueue.start();

    taskQueue.runTask = function () {
        chrome.browserAction.setBadgeText({"text": "↑↓"});
        taskQueue.setRunning(true);
        var task = this.queue.shift();
        console.log("run task:" + task);

        if (task.type == "add") {
            console.log("add:", task.changedDoc);
            //TODO 判断是否存在 tag
            //TODO 判断该tag下是否存在书签
            //TODO 新增书签
            search({"title": task.changedDoc.title}, function (tags) {
                console.log("search tags:", tags);
                findAddBookMark(task.changedDoc, ddp.getCollection("bookmarks"), function (addedBookMark) {
                    console.log("find bookmark:", addedBookMark);
                    console.log("tags != null && tags.length > 0", tags != null && tags.length > 0);
                    if (tags != null && tags.length > 0) {
                        for (var j in tags) {
                            var tag = tags[j];
                            console.log(tag);
                            console.log(addedBookMark.title, tag, addedBookMark.url);
                            search({"title": addedBookMark.title, "url": addedBookMark.url}, function (bookmarks) {
                                console.log("search bookmark:", bookmarks);
                                if (bookmarks != null && bookmarks.length > 0) {
                                    for (var i in bookmarks) {
                                        var bm = bookmarks[i];
                                        console.log("bm:", bm, bm.parentId != tag.id);
                                        if (bm.parentId != tag.id) {
                                            chrome.bookmarks.create({"parentId": tag.id, "title": addedBookMark.title, "url": addedBookMark.url}, function () {
                                                console.log("create success");
                                                taskQueue.setRunning(false);
                                                taskQueue.start();
                                            });
                                            break;
                                        } else {
                                            continue;
                                        }
                                    }
                                } else {
                                    chrome.bookmarks.create({"parentId": tag.id, "title": addedBookMark.title, "url": addedBookMark.url}, function () {
                                        console.log("create success");
                                        taskQueue.setRunning(false);
                                        taskQueue.start();
                                    });
                                }
                            });
                        }
                    } else {
                        console.log("title:",task.changedDoc.title);
                        chrome.bookmarks.create({"parentId": "1", "title": task.changedDoc.title}, function (newTag) {
                            console.log("newTag",newTag,addedBookMark);
                            chrome.bookmarks.create({"parentId": newTag.id, "title": addedBookMark.title, "url": addedBookMark.url}, function (newbm) {
                                console.log(newbm);
                                taskQueue.setRunning(false);
                                taskQueue.start();
                            });
                        });
                    }
                });
            });
        } else if (task.type == "remove") {
            console.log("remove");
            //TODO 先找到目录，然后找到书签，最后一起删除掉
            console.log(task.changedDoc.title);
            search({"title": task.changedDoc.title}, function (tags) {
                console.log("search:",tags);
                if (tags != null && tags.length > 0) {
                    tags.forEach(function (tag) {
                        search({"url": task.changedDoc.url}, function (bookmarks) {
                            console.log("search bookmark:", bookmarks);
                            if (bookmarks != null && bookmarks.length > 0) {
                                bookmarks.forEach(function (bm) {
                                    console.log("bm:", bm, bm.parentId != tag.id);
                                    if (bm.parentId == tag.id) {
                                        chrome.bookmarks.remove(bm.id, function () {
                                            console.log("remove success");
                                            taskQueue.setRunning(false);
                                            taskQueue.start();
                                        });
                                    } else {
                                        taskQueue.setRunning(false);
                                        taskQueue.start();
                                    }
                                });
                            } else {
                                taskQueue.setRunning(false);
                                taskQueue.start();
                            }
                        });
                    });
                } else {
                    taskQueue.setRunning(false);
                    taskQueue.start();
                }
            });
        } else {
            taskQueue.setRunning(false);
            taskQueue.start();
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
                console.log("watch tags:",changedDoc,message);
                if (message === "added") {
                    taskQueue.push({"type": "add", "changedDoc": changedDoc});
                } else if (message === "removed") {
                    taskQueue.push({"type": "remove", "changedDoc": changedDoc});
                }
            });
        });
    });
})
.fail(function() {
    //TODO 处理DDP连接失败
    console.log("connect error");
});

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
        console.log(parenBookmarks);
        bookmark.tag = tag;
        chrome.browserAction.setBadgeText({"text": "↑↑"});
        $.post(serviceUrl+"/add",bookmark, function(data,status){
            chrome.browserAction.setBadgeText({"text": ""});
        });
    });
});
