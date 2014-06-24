//定时刷新

setInterval(function () {
    var userId = window.localStorage.getItem("Meteor.userId");
    var userIdBak = window.localStorage.getItem("userIdBak");
    var email = window.localStorage.getItem("userEmail");
    if (userId != userIdBak) {
        chrome.runtime.sendMessage({"userId": userId,"email":email}, function (response) {
            console.log(response);
        });
        window.localStorage.setItem("userIdBak", userId);
    }
}, 2000);
