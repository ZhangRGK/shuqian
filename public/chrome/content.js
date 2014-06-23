
var userId = '';
$(function() {
    var theUserId = localStorage.getItem('Meteor.userId');
    if (theUserId == "null") {

    }
})
//$(document).bind("click",function(){
////$('body').click( function(){
//        if (theUserId != userId){
//            console.log(theUserId);
//            console.log(userId);
//            chrome.runtime.sendMessage({userId: theUserId}, function(response) {
//                console.log(response.farewell);
//            });
//            userId = theUserId;
//        }
//    }
//);
//});

/*以下无效
$(function() {

console.log('bigzhu');
var addEvent = (function () {
  if (document.addEventListener) {
    return function (el, type, fn) {
      if (el && el.nodeName || el === window) {
        el.addEventListener(type, fn, false);
      } else if (el && el.length) {
        for (var i = 0; i < el.length; i++) {
          addEvent(el[i], type, fn);
        }
      }
    };
  } else {
    return function (el, type, fn) {
      if (el && el.nodeName || el === window) {
        el.attachEvent('on' + type, function () { return fn.call(el, window.event); });
      } else if (el && el.length) {
        for (var i = 0; i < el.length; i++) {
          addEvent(el[i], type, fn);
        }
      }
    };
  }
})();

addEvent(window, 'storage', function (event) {
  console.log(event);
  if (event.key == 'storage-event-test') {
    output.innerHTML = event.newValue;
  }
});



});
*/
