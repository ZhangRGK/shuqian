var userId = localStorage.getItem('userId');

//var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
var ddp = new MeteorDdp("ws://localhost:3000/websocket");

chrome.browserAction.setBadgeBackgroundColor({"color":[255,0,0,255]});

ddp.connect().done(function () {
    console.log("connect");
    chrome.browserAction.setBadgeText({"text":"↓"});

    var bookMarks = ddp.subscribe('bookmarks', [userId]);
    bookMarks.fail(function (error) {
        chrome.browserAction.setBadgeText({"text":"∞"});
        console.log(error);
    });

    //单个同步
    bookMarks.done(function () {
        ddp.watch('bookmarks', function (changedDoc, message) {
            console.log(changedDoc)
            console.log("The bookMarks collection changed. Here's what changed: ", changedDoc, message);

            // Was it removed?
            if (message === "removed") {
                chrome.bookmarks.remove(changedDoc.id);
            }
            chrome.browserAction.setBadgeText({"text":""});
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
