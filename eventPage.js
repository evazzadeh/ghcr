// Generated by CoffeeScript 1.4.0
(function() {

  console.log('init evetPage');

  chrome.webNavigation.onCompleted.addListener(function(details) {
    console.log('onCompleted');
    return chrome.tabs.sendMessage(details.tabId, {}, function(response) {
      return console.log(response, 'response');
    });
  });

  chrome.webNavigation.onHistoryStateUpdated.addListener(function(details) {
    console.log('onHistoryStateUpdated');
    return chrome.tabs.sendMessage(details.tabId, {}, function(response) {
      return console.log(response, 'response');
    });
  });

}).call(this);
