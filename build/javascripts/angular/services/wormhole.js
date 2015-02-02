(function() {
  var __hasProp = {}.hasOwnProperty;

  lemur.service('Wormhole', [
    '$log', '$timeout', function($log, $timeout) {
      var eventHorizon;
      eventHorizon = new Object;
      $timeout(function() {
        var websocket;
        websocket = new WebSocket('ws://' + window.document.location.host);
        websocket.onmessage = function(message) {
          var data, dataType, value, _results;
          data = angular.fromJson(message.data);
          _results = [];
          for (dataType in data) {
            if (!__hasProp.call(data, dataType)) continue;
            value = data[dataType];
            eventHorizon[dataType](value);
            _results.push(eventHorizon.scope.$apply());
          }
          return _results;
        };
        return eventHorizon.send = function(message) {
          return websocket.send(message);
        };
      });
      return eventHorizon;
    }
  ]);

}).call(this);
