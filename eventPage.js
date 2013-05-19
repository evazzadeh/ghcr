// Generated by CoffeeScript 1.3.3
(function() {
  var ghcrRender;

  console.log('init evetPage');

  ghcrRender = function(details) {
    if (!/^https?:\/\/(.*\.)?github\.com/.test(details.url)) {
      return false;
    }
    return chrome.tabs.sendMessage(details.tabId, {}, function(response) {
      return console.log(response, 'response');
    });
  };

  chrome.webNavigation.onCompleted.addListener(function(details) {
    console.log('onCompleted');
    return ghcrRender(details);
  });

  chrome.webNavigation.onHistoryStateUpdated.addListener(function(details) {
    console.log('onHistoryStateUpdated');
    return ghcrRender(details);
  });

}).call(this);
