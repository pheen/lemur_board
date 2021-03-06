lemur.service 'Wormhole', [
  '$log', '$timeout',
  ($log, $timeout) ->
    eventHorizon = new Object

    $timeout ->
      websocket = new WebSocket('ws://' + window.document.location.host)
      websocket.onmessage = (message) ->
        data = angular.fromJson(message.data)

        for own dataType, value of data
          eventHorizon[dataType](value)
          eventHorizon.scope.$apply()

      eventHorizon.send = (message) ->
        websocket.send(message)

    eventHorizon
]
