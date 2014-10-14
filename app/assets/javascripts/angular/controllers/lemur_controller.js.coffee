lemur.controller 'LemurController', [
  '$scope', '$element', '$http',
  ($scope, $element, $http) ->
    $scope.users = []

    $scope.ws = new WebSocket('ws://' + window.document.location.host)
    $scope.ws.onmessage = (message) ->
      data = angular.fromJson(message.data)

      $scope.$apply ->
        if data.current_user
          $scope.current_user = data.current_user

        if data.users
          $scope.users = data.users

        if data.challenges
          for challenge in data.challenges
            challenge.challenger_id = parseInt(challenge.challenger_id, 10)
            challenge.opponent_id = parseInt(challenge.opponent_idp, 10)
            challenge.timestamp = parseInt(challenge.timestamp, 10)

          $scope.challenges = data.challenges

        if data.newChallenge
          data.newChallenge.challenger_id = parseInt(data.newChallenge.challenger_id, 10)
          data.newChallenge.opponent_id = parseInt(data.newChallenge.opponent_idp, 10)
          data.newChallenge.timestamp = parseInt(data.newChallenge.timestamp, 10)

          $scope.challenges.push(data.newChallenge)

    $scope.sendChallenge = ->
      msg = JSON.stringify(issueChallenge: { email: $scope.userToSmite, time: $scope.challengeStart })
      $scope.ws.send(msg)

    $scope.openChallengeForm = (user) ->
      $scope.userToSmite = user.email
]
