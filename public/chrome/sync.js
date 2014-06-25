var userId = localStorage.getItem('userId');

//var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
var ddp = new MeteorDdp("ws://localhost:3000/websocket");

chrome.browserAction.setBadgeBackgroundColor({"color":[255,0,0,255]});

ddp.connect().done(function () {
    console.log("connect");

    var bookmarks = ddp.subscribe('ddp_bookmarks',[userId])
        .fail(function (error) {
            chrome.browserAction.setBadgeText({"text":"∞"});
            console.log(error);
        });
    var tags = ddp.subscribe('ddp_tags',[userId])
        .fail(function (error) {
            chrome.browserAction.setBadgeText({"text":"∞"});
            console.log(error);
        });

    //单个同步
    tags.done(function () {
        bookmarks.done(function() {
            console.log(ddp);
            console.log(ddp.getCollection("tags"));
            console.log(ddp.getCollection("ddp_tags"));
            ddp.watch('Tags', function (changedDoc, message) {
                chrome.browserAction.setBadgeText({"text":"↓"});
                console.log("The bookMarks collection changed. Here's what changed: ", changedDoc, message);

                // Was it removed?
                if (message === "removed") {
                    chrome.bookmarks.remove(changedDoc.id);
                }
                chrome.browserAction.setBadgeText({"text":""});
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
