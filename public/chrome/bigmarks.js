var userId = localStorage.getItem('userId');
var userEmail = localStorage.getItem("userEmail");
var serviceUrl = 'http://localhost:3000';
//var serviceUrl = 'http://shuqian.bigzhu.org';

var init = function() {
    if (userId === null || userId === "null") {
        $("#gravatar_button").hide();
        $("#uploadToDefault").show();
        $("#uploadToUser").hide();
        $("html,body").css("height","40px");
    } else {
        $("#uploadToDefault").hide();
        $("#uploadToUser").show();

        url = "http://www.gravatar.com/avatar/"+MD5(userEmail);
        img = '<img src="'+url+'" class="img-thumbnail" width="48"/>';

        $("#gravatar").attr("src", url);
        $("#gravatar_button").show();
        $("#user").text(userEmail);

        $("html,body").css("height","50px");
    }
}();

$("#openApp").on("click", function () {
    chrome.tabs.create({"url": serviceUrl});
});

$("#uploadToDefault").on("click", function() {
    chrome.bookmarks.getTree(function(bookmarkTreeNodes) {
        chrome.browserAction.setBadgeText({"text": "↑↑"});
        $.post(serviceUrl+"/upload",{"userId":null,"data":bookmarkTreeNodes}, function(data,status) {
            console.log("data:"+data+" status:"+status);
            chrome.browserAction.setBadgeText({"text": ""});
        });
    });
});

$("#uploadToUser").on("click", function() {
    chrome.bookmarks.getTree(function(bookmarkTreeNodes) {
        chrome.browserAction.setBadgeText({"text": "↑↑"});
        $.post(serviceUrl+"/upload",{"userId":userId,"data":bookmarkTreeNodes}, function(data,status){
            console.log("data:"+data+" status:"+status);
            chrome.browserAction.setBadgeText({"text": ""});
        });
    });
});

function update(id, bookmarks){
    console.log("update");
    chrome.browserAction.setBadgeText({"text":"↑"});
    console.log(bookmarks);
    bookmarks.id = id;
    $.post(serviceUrl+"/update",{"userId":userId,"data":bookmarks},function(data,status) {
        console.log("data:"+data+" status:"+status);
        chrome.browserAction.setBadgeText({"text": ""});
    });
}

chrome.bookmarks.onCreated.addListener(function(id,bookmark) {
    console.log(id,":",bookmark);
});

console.log(chrome.bookmarks.onMoved);
chrome.bookmarks.onMoved.addListener(update);
