var userId = localStorage.getItem('userId');
var userEmail = localStorage.getItem("userEmail");
var serviceUrl = 'http://shuqian.bigzhu.org';
//var serviceUrl = 'http://localhost:3000';

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

function post(url, data){
    var method = "POST";

    var async = true;

    var request = new XMLHttpRequest();

    request.open(method, url, async);

    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

    //request.onreadystatechange(function(http) {
    //    if(http.readyState == 4 && http.status == 200) {
    //        chrome.browserAction.setBadgeText({"text": ""});
    //    }
    //});

    request.send(data);
}
$("#uploadToDefault").on("click", function() {
    chrome.bookmarks.getTree(function(bookmarkTreeNodes) {
        chrome.browserAction.setBadgeText({"text": "↑↑"});
        post(serviceUrl+"/upload",JSON.stringify({"userId":null,"data":bookmarkTreeNodes}));
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

/*
function remove(id, bookmarks, test){
    console.log("remove");
    console.log(bookmarks);
    console.log(test);
    node2 = chrome.bookmarks.get(id, function(node){
            console.log(node);
            post(serviceUrl+"/remove", JSON.stringify(bookmarks));
            });
    console.log(node2);
}
*/

function update(id, bookmarks){
    console.log("update");
    chrome.browserAction.setBadgeText({"text":"↑"});
    console.log(bookmarks);
    bookmarks.id = id;
    post(serviceUrl+"/update", JSON.stringify({"userId":userId,"data":bookmarks}));
}
//chrome.bookmarks.onRemoved.addListener(remove);
chrome.bookmarks.onCreated.addListener(function(id,bookmark) {
    console.log(id,":",bookmark);
});
//只有title和url改变时会触发
//chrome.bookmarks.onChanged.addListener(update);

console.log(chrome.bookmarks.onMoved);
chrome.bookmarks.onMoved.addListener(update);
