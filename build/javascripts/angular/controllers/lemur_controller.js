(function() {
  lemur.controller('LemurController', [
    '$scope', '$element', '$http', function($scope, $element, $http) {
      $scope.users = [];
      $scope.ws = new WebSocket('ws://' + window.document.location.host);
      $scope.ws.onmessage = function(message) {
        var data;
        data = angular.fromJson(message.data);
        return $scope.$apply(function() {
          var challenge, _i, _len, _ref;
          if (data.current_user) {
            $scope.current_user = data.current_user;
          }
          if (data.users) {
            $scope.users = data.users;
          }
          if (data.challenges) {
            _ref = data.challenges;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              challenge = _ref[_i];
              challenge.challenger_id = parseInt(challenge.challenger_id, 10);
              challenge.opponent_id = parseInt(challenge.opponent_idp, 10);
              challenge.timestamp = parseInt(challenge.timestamp, 10);
            }
            $scope.challenges = data.challenges;
          }
          if (data.newChallenge) {
            data.newChallenge.challenger_id = parseInt(data.newChallenge.challenger_id, 10);
            data.newChallenge.opponent_id = parseInt(data.newChallenge.opponent_idp, 10);
            data.newChallenge.timestamp = parseInt(data.newChallenge.timestamp, 10);
            return $scope.challenges.push(data.newChallenge);
          }
        });
      };
      $scope.sendChallenge = function() {
        var msg;
        msg = JSON.stringify({
          issueChallenge: {
            email: $scope.userToSmite,
            time: $scope.challengeStart
          }
        });
        return $scope.ws.send(msg);
      };
      return $scope.openChallengeForm = function(user) {
        return $scope.userToSmite = user.email;
      };
    }
  ]);

}).call(this);
