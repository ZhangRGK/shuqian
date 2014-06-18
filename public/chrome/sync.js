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


var ddp = new MeteorDdp("ws://localhost:3000/websocket");
ddp.connect().done(function() {
    console.log('Connected!');

    //ddp.subscribe('bookMarks').fail(function(error) {
    //  console.log(error);
    //});

    var bookMarks = ddp.subscribe('bookmarks');
    bookMarks.fail(function(error) {
      console.log(error);
    });

    bookMarks.done(function(){
        ddp.watch('bookmarks', function(changedDoc, message) {
          console.log("The bookMarks collection changed. Here's what changed: ", changedDoc, message);

          // Was it removed?
          if (message === "removed") {
            console.log("This document doesn't exist in our collection anymore :(");
          }

        });

    });
});

