//var ddp = new MeteorDdp("ws://localhost:3000/websocket");
//
//ddp.connect().then(function () {
//    console.log('connected');
//    ddp.subscribe("bookMarks");
//    ddp.watch("bookMarks", function (changedDoc, message) {
//        console.log(changedDoc);
//        console.log(message);
//    });
//});
var userId = localStorage.getItem('userId');
console.log(userId);

var ddp = new MeteorDdp("ws://localhost:3000/websocket");
ddp.connect().done(function() {
    console.log('Connected!');

    //ddp.subscribe('bookMarks').fail(function(error) {
    //  console.log(error);
    //});

    var bookMarks = ddp.subscribe('bookmarks', [userId]);
    bookMarks.fail(function(error) {
      console.log(error);
    });

    bookMarks.done(function(){
        ddp.watch('bookmarks', function(changedDoc, message) {
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
  function(request, sender, sendResponse) {
    console.log('userId='+request.userId);
    localStorage.setItem('userId', request.userId);
  });
