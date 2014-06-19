var  userId = localStorage.getItem('Meteor.userId');
console.log(userId);
chrome.runtime.sendMessage({userId: userId}, function(response) {
  console.log(response.farewell);
});
