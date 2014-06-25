var userId = localStorage.getItem('userId');
var userEmail = localStorage.getItem("userEmail");
var serviceUrl = 'http://shuqian.bigzhu.org';
serviceUrl = 'http://localhost:3000';

var init = function() {
    if (userId == null || userId == "null") {
        $("#uploadToDefault").removeClass("hidden");
        $("#uploadToUser").addClass("hidden");
        $("#userEmail").addClass("hidden");
        $("html,body").css("height","150px");
    } else {
        $("#uploadToDefault").addClass("hidden");
        $("#uploadToUser").removeClass("hidden");
        $("#userEmail").html(userEmail).removeClass("hidden");
        $("html,body").css("height","170px");
    }
}();

$("#openApp").on("click", function () {
    chrome.tabs.create({"url": serviceUrl});
});

$("#uploadToDefault").on("click", function() {
    chrome.bookmarks.getTree(function(bookmarkTreeNodes) {
        post(serviceUrl+"/upload",JSON.stringify({"userId":null,"data":bookmarkTreeNodes}));
    });
});

$("#uploadToUser").on("click", function() {
    chrome.bookmarks.getTree(function(bookmarkTreeNodes) {
        post(serviceUrl+"/upload",JSON.stringify({"userId":userId,"data":bookmarkTreeNodes}));
    });
});

function post(url, data){
    var method = "POST";

    var async = true;

    var request = new XMLHttpRequest();

    request.open(method, url, async);

    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");

    request.onreadystatechange(function() {
        if(http.readyState == 4 && http.status == 200) {
            alert(http.responseText);
        }
    })

    request.send(data);
}
//
function add(id, bookmarks){
//    console.log("add");
//    console.log(bookmarks);
//    bookmarks.userId = userId;
    post(serviceUrl+"/add", JSON.stringify({"userId":userId,"data":bookmarks}));
}

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
//上载全部标签
//document.getElementById("upload").onclick = function() {
//    chrome.bookmarks.getTree(
//            function(bookmarkTreeNodes) {
//            var  userId = localStorage.getItem('userId');
//            bookmarkTreeNodes[0].userId=userId;
//            console.log(bookmarkTreeNodes[0]);
//            post(serviceUrl+"/upload", JSON.stringify(bookmarkTreeNodes[0]));
//            });
//};
