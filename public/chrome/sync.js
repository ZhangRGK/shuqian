var userId = localStorage.getItem('userId');

var ddp = new MeteorDdp("ws://shuqian.bigzhu.org/websocket");
ddp = new MeteorDdp("ws://0.0.0.0/websocket");
ddp.connect().done(function () {
    console.log('Connected!');

    //ddp.subscribe('bookMarks').fail(function(error) {
    //  console.log(error);
    //});

    var bookMarks = ddp.subscribe('bookmarks', [userId]);
    bookMarks.fail(function (error) {
        console.log(error);
    });

    bookMarks.done(function () {
        ddp.watch('bookmarks', function (changedDoc, message) {
            console.log("The bookMarks collection changed. Here's what changed: ", changedDoc, message);

            // Was it removed?
            if (message === "removed") {
                chrome.bookmarks.remove(changedDoc.id);
            }

        });

    });
});

//取到userId,插入localStorage
chrome.runtime.onMessage.addListener(
    function (request, sender, sendResponse) {
        console.log(request.email);
        localStorage.setItem('userId', request.userId);
        localStorage.setItem("userEmail", request.email);
    }
);
