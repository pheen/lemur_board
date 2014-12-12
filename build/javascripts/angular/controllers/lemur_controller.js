(function() {
  lemur.controller('LemurController', [
    '$scope', '$window', '$element', '$http', '$famous', 'Wormhole', function($scope, $window, $element, $http, $famous, Wormhole) {
      var EventHandler, calcuateHeight;
      calcuateHeight = function() {
        $scope.windowHeight = $window.innerHeight;
        $scope.barHeight = $window.innerHeight * 0.07;
        $scope.bodyHeight = $window.innerHeight - $scope.barHeight;
        $scope.calendarItemHeight = $window.innerHeight * 0.08;
        return $scope.profileCalendarHeight = $scope.calendarItemHeight * 5;
      };
      calcuateHeight();
      angular.element($window).bind('resize', function() {
        return $scope.$apply(function() {
          return calcuateHeight();
        });
      });
      EventHandler = $famous['famous/core/EventHandler'];
      $scope.mainScrollHandler = new EventHandler();
      $scope.profileScrollHandler = new EventHandler();
      $scope.calendarScrollHandler = new EventHandler();
      $scope.options = {
        mainScrollView: {
          direction: 0,
          paginated: true
        },
        calendarScrollView: {
          direction: 1
        }
      };
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
          challenge.time = challenge.accepted ? challenge.timestamp : 'pending';
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
      $scope.clearChallenge = function() {
        return $scope.userToSmite = null;
      };
      debugger;
    }
  ]);

}).call(this);
