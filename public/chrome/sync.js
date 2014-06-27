var userId = localStorage.getItem('userId');

// 设定徽章背景色
chrome.browserAction.setBadgeBackgroundColor({"color": [255, 0, 0, 255]});

//取到userId,插入localStorage
chrome.runtime.onMessage.addListener(
    function (request, sender, sendResponse) {
        localStorage.setItem('userId', request.userId);
        localStorage.setItem("userEmail", request.email);
    }
);

var serviceUrl = 'http://shuqian.bigzhu.org';

//浏览器新增bookmarks
chrome.bookmarks.onCreated.addListener(function(id,bookmark) {
    parentId = bookmark.parentId;
    bookmark.userId = userId;
    chrome.bookmarks.get(parentId, function(parenBookmarks){
        tag = parenBookmarks[0].title;
        bookmark.tag = tag;
        chrome.browserAction.setBadgeText({"text": "↑↑"});
        $.post(serviceUrl+"/add",bookmark, function(data,status){
            chrome.browserAction.setBadgeText({"text": ""});
        });
    });
});
