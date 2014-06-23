var userId = localStorage.getItem('userId');
var serviceUrl = 'http://shuqian.bigzhu.org';
serviceUrl = 'http://0.0.0.0';

if(userId == "null") {
    chrome.tabs.create({'url': serviceUrl});
}

function getBookMarks(){
    chrome.bookmarks.getTree(
            function(bookmarkTreeNodes) {
            console.log(bookmarkTreeNodes);
            });
}
function show(id, bookmarks){
    console.log(id);
    console.log(bookmarks);
}


function post(url, data){
    var method = "POST";
    var postData = "Some data";

    // You REALLY want async = true.
    // Otherwise, it'll block ALL execution waiting for server response.
    var async = true;

    var request = new XMLHttpRequest();

    request.open(method, url, async);

    request.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
    // Or... request.setRequestHeader("Content-Type", "text/plain;charset=UTF-8");
    // Or... whatever

    // Actually sends the request to the server.
    request.send(data);
}

function add(id, bookmarks){
    post(currentUser+"/add", JSON.stringify(bookmarks));
}
function remove(id, bookmarks){
    post(serviceUrl+"/remove", JSON.stringify(bookmarks));
}
function update(id, bookmarks){
    console.log('update');
    bookmarks.id = id;
    console.log(bookmarks);
    post(serviceUrl+"/update", JSON.stringify(bookmarks));
}
chrome.bookmarks.onRemoved.addListener(remove);
chrome.bookmarks.onCreated.addListener(add);
//只有title和url改变时会触发
//chrome.bookmarks.onChanged.addListener(update);
chrome.bookmarks.onMoved.addListener(update);
//上载全部标签
document.getElementById("upload").onclick = function() {
    chrome.bookmarks.getTree(
            function(bookmarkTreeNodes) {
            var  userId = localStorage.getItem('userId');
            bookmarkTreeNodes[0].userId=userId;
            console.log(bookmarkTreeNodes[0]);
            post(serviceUrl+"/upload", JSON.stringify(bookmarkTreeNodes[0]));
            });
};



