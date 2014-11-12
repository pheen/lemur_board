(function() {
  lemur.controller('LemurController', [
    '$scope', '$element', '$http', 'Wormhole', function($scope, $element, $http, Wormhole) {
      $scope.users = [];
      Wormhole.scope = $scope;
      Wormhole.current_user = function(user) {
        return $scope.currentUser = user;
      };
      Wormhole.users = function(users) {
        $scope.users = users;
        return $scope.opponents = _.omit(users, $scope.currentUser.id);
      };
      Wormhole.challenges = function(challenges) {
        var challenge, _i, _len;
        for (_i = 0, _len = challenges.length; _i < _len; _i++) {
          challenge = challenges[_i];
          challenge.challenger_id = parseInt(challenge.challenger_id, 10);
          challenge.opponent_id = parseInt(challenge.opponent_id, 10);
          challenge.timestamp = new Date(parseInt(challenge.timestamp, 10) * 1000);
        }
        return $scope.challenges = challenges;
      };
      Wormhole.new_challenge = function(challenge) {
        challenge.challenger_id = parseInt(challenge.challenger_id, 10);
        challenge.opponent_id = parseInt(challenge.opponent_idp, 10);
        challenge.timestamp = new Date(parseInt(challenge.timestamp, 10) * 1000);
        return $scope.challenges.push(challenge);
      };
      $scope.sendChallenge = function() {
        var msg;
        msg = JSON.stringify({
          issueChallenge: {
            challenger_email: $scope.currentUser.emai,
            opponent_email: $scope.userToSmite,
            time: $scope.challengeStartTime
          }
        });
        return Wormhole.send(msg);
      };
      $scope.openChallengeForm = function(user) {
        return $scope.userToSmite = user.email;
      };
      return $scope.clearChallenge = function() {
        return $scope.userToSmite = null;
      };
    }
  ]);

}).call(this);
