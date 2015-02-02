(function() {
  var formatTimeForChallenge;

  formatTimeForChallenge = function(dateTime) {
    if (dateTime > new Date) {
      return "" + (dateTime.getHours()) + ":" + (dateTime.getMinutes());
    } else {
      return dateTime.toLocaleDateString();
    }
  };

  lemur.controller('LemurController', [
    '$scope', '$window', '$element', '$timeout', '$http', '$famous', 'Wormhole', function($scope, $window, $element, $timeout, $http, $famous, Wormhole) {
      var EventHandler, Transitionable, calcuateHeight, date, _i, _j, _k, _l, _m, _n, _o, _p, _q, _r, _results, _results1, _results10, _results11, _results12, _results2, _results3, _results4, _results5, _results6, _results7, _results8, _results9, _s, _t, _u;
      Transitionable = $famous['famous/transitions/Transitionable'];
      EventHandler = $famous['famous/core/EventHandler'];
      $scope.opts = {
        container: {
          properties: {
            overflow: 'hidden',
            'z-index': 1
          }
        },
        datepickerContainer: {
          properties: {
            border: '5px solid rgb(44, 51, 55)',
            overflow: 'hidden',
            'z-index': 1
          }
        }
      };
      $scope.events = {};
      $scope.events.mainScroll = new EventHandler();
      $scope.events.calendarScroll = new EventHandler();
      $scope.events.opponentsScroll = new EventHandler();
      $scope.events.challengeYearScroll = new EventHandler();
      $scope.events.challengeMonthScroll = new EventHandler();
      $scope.events.challengeDayScroll = new EventHandler();
      $scope.events.challengeHourScroll = new EventHandler();
      $scope.events.challengeMinScroll = new EventHandler();
      $scope.events.challengePerScroll = new EventHandler();
      $scope.years = [15, 16];
      $scope.months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
      $scope.days = {
        1: (function() {
          _results = [];
          for (_i = 1; _i <= 31; _i++){ _results.push(_i); }
          return _results;
        }).apply(this),
        2: (function() {
          _results1 = [];
          for (_j = 1; _j <= 28; _j++){ _results1.push(_j); }
          return _results1;
        }).apply(this),
        3: (function() {
          _results2 = [];
          for (_k = 1; _k <= 31; _k++){ _results2.push(_k); }
          return _results2;
        }).apply(this),
        4: (function() {
          _results3 = [];
          for (_l = 1; _l <= 30; _l++){ _results3.push(_l); }
          return _results3;
        }).apply(this),
        5: (function() {
          _results4 = [];
          for (_m = 1; _m <= 31; _m++){ _results4.push(_m); }
          return _results4;
        }).apply(this),
        6: (function() {
          _results5 = [];
          for (_n = 1; _n <= 30; _n++){ _results5.push(_n); }
          return _results5;
        }).apply(this),
        7: (function() {
          _results6 = [];
          for (_o = 1; _o <= 31; _o++){ _results6.push(_o); }
          return _results6;
        }).apply(this),
        8: (function() {
          _results7 = [];
          for (_p = 1; _p <= 31; _p++){ _results7.push(_p); }
          return _results7;
        }).apply(this),
        9: (function() {
          _results8 = [];
          for (_q = 1; _q <= 30; _q++){ _results8.push(_q); }
          return _results8;
        }).apply(this),
        10: (function() {
          _results9 = [];
          for (_r = 1; _r <= 31; _r++){ _results9.push(_r); }
          return _results9;
        }).apply(this),
        11: (function() {
          _results10 = [];
          for (_s = 1; _s <= 30; _s++){ _results10.push(_s); }
          return _results10;
        }).apply(this),
        12: (function() {
          _results11 = [];
          for (_t = 1; _t <= 31; _t++){ _results11.push(_t); }
          return _results11;
        }).apply(this)
      };
      $scope.hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
      $scope.mins = (function() {
        _results12 = [];
        for (_u = 0; _u <= 59; _u++){ _results12.push(_u); }
        return _results12;
      }).apply(this);
      $scope.pers = ['AM', 'PM'];
      date = new Date;
      $scope.challengeMonth = date.getMonth() + 1;
      $scope.challengeYearIndex = $scope.years.indexOf(parseInt(date.getFullYear().toString().substr(2, 2), 10));
      $scope.challengeMonthIndex = $scope.months.indexOf(date.getMonth() + 1);
      $scope.challengeDayIndex = $scope.days[$scope.challengeMonth].indexOf(date.getDay() + 1);
      $scope.challengeHourIndex = $scope.hours.indexOf(date.getHours() <= 12 ? date.getHours() : date.getHours() - 12);
      $scope.challengeMinIndex = $scope.mins.indexOf(date.getMinutes());
      $scope.challengePerIndex = $scope.pers.indexOf(date.getHours() <= 12 ? 'AM' : 'PM');
      $scope.options = {
        mainScrollView: {
          direction: 0,
          paginated: true
        },
        calendarScrollView: {
          direction: 1
        },
        challengeDateScrollView: {
          direction: 1,
          paginated: true
        }
      };
      $scope.selectOpponent = function(opponent) {
        return $scope.challenge.opponent = opponent;
      };
      $scope.submitChallenge = function() {
        var datetime, dayIndex, hourIndex, minIndex, monthIndex, msg, perIndex, yearIndex;
        yearIndex = $famous.find('#year')[0].renderNode._node.getIndex();
        monthIndex = $famous.find('#month')[0].renderNode._node.getIndex();
        dayIndex = $famous.find('#day')[0].renderNode._node.getIndex();
        hourIndex = $famous.find('#hour')[0].renderNode._node.getIndex();
        minIndex = $famous.find('#min')[0].renderNode._node.getIndex();
        perIndex = $famous.find('#per')[0].renderNode._node.getIndex();
        datetime = new Date("20" + $scope.years[yearIndex], $scope.months[monthIndex] - 1, $scope.days[$scope.challengeMonth][dayIndex], $scope.pers[perIndex] === 'AM' ? $scope.hours[hourIndex] : $scope.hours[hourIndex] + 12, $scope.mins[minIndex]);
        if (datetime.toString() === "Invalid Date") {
          $scope.error = 'Invalid Date';
          return console.log('invalid date');
        } else if (!$scope.challenge.opponent) {
          $scope.error = 'Missing opponent';
          return console.log('Missing opponent');
        } else {
          $scope.error = '';
          msg = JSON.stringify({
            issueChallenge: {
              challenger_email: $scope.currentUser.email,
              opponent_email: $scope.challenge.opponent.email,
              time: datetime.getTime()
            }
          });
          Wormhole.send(msg);
          $scope.growl = 'Challenge Submitted';
          $scope.growlPosition.set($scope.windowWidth * 0.1, {
            duration: 350,
            curve: 'easeInOut'
          });
          return $timeout(function() {
            return $scope.growlPosition.set(-$scope.growlHeight, {
              duration: 350,
              curve: 'easeInOut'
            });
          }, 1500);
        }
      };
      $scope.selectedOpponent = function(opponent) {
        return $scope.challenge.opponent === opponent;
      };
      $scope.openChallengePane = function() {
        $scope.challengePaneActive = !$scope.challengePaneActive;
        console.log('hi');
        console.log($scope.challengePaneActive);
        if ($scope.challengePaneActive) {
          return $scope.barDynHeight.set([$window.innerWidth, $window.innerHeight], {
            duration: 350,
            curve: 'easeInOut'
          });
        } else {
          return $scope.barDynHeight.set([$window.innerWidth, $window.innerHeight * 0.07], {
            duration: 350,
            curve: 'easeInOut'
          });
        }
      };
      $scope.acceptChallenge = function(challenge) {
        var index, msg;
        index = $scope.challengesToAccept.indexOf(challenge);
        $scope.challengesToAccept.splice(index, 1);
        $scope.challenges.push(challenge);
        msg = JSON.stringify({
          acceptChallenge: challenge.id
        });
        Wormhole.send(msg);
        $scope.growl = 'Challenge Accepted';
        $scope.growlPosition.set($scope.windowWidth * 0.1, {
          duration: 350,
          curve: 'easeInOut'
        });
        return $timeout(function() {
          return $scope.growlPosition.set(-$scope.growlHeight, {
            duration: 350,
            curve: 'easeInOut'
          });
        }, 1500);
      };
      $scope.challengePaneActive = false;
      $scope.challenge = {};
      calcuateHeight = function() {
        $scope.windowHeight = $window.innerHeight;
        $scope.windowWidth = $window.innerWidth;
        $scope.growlHeight = $scope.windowHeight / 10;
        $scope.barHeight = $window.innerHeight * 0.07;
        $scope.barDynHeight = new Transitionable([$scope.windowWidth, $window.innerHeight * 0.07]);
        $scope.bodyHeight = $window.innerHeight - $scope.barHeight;
        $scope.calendarItemHeight = $window.innerHeight * 0.12;
        return $scope.profileCalendarHeight = $scope.calendarItemHeight * 5;
      };
      calcuateHeight();
      $scope.growlPosition = new Transitionable(-$scope.growlHeight);
      angular.element($window).bind('resize', function() {
        return $scope.$apply(function() {
          return calcuateHeight();
        });
      });
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
        var challenge, _len, _results13, _v;
        $scope.challenges = [];
        $scope.challengesToAccept = [];
        _results13 = [];
        for (_v = 0, _len = challenges.length; _v < _len; _v++) {
          challenge = challenges[_v];
          challenge.challenger_id = parseInt(challenge.challenger_id, 10);
          challenge.opponent_id = parseInt(challenge.opponent_id, 10);
          challenge.timestamp = new Date(parseInt(challenge.timestamp, 10));
          challenge.time = challenge.accepted ? formatTimeForChallenge(challenge.timestamp) : 'pending';
          if (challenge.opponent_id === parseInt($scope.currentUser.id, 10)) {
            debugger;
          }
          if (challenge.opponent_id === parseInt($scope.currentUser.id, 10) && challenge.accepted === false) {
            _results13.push($scope.challengesToAccept.push(challenge));
          } else {
            _results13.push($scope.challenges.push(challenge));
          }
        }
        return _results13;
      };
      Wormhole.new_challenge = function(challenge) {
        challenge.challenger_id = parseInt(challenge.challenger_id, 10);
        challenge.opponent_id = parseInt(challenge.opponent_id, 10);
        challenge.timestamp = new Date(parseInt(challenge.timestamp, 10));
        challenge.accepted = challenge.accepted;
        challenge.time = challenge.accepted ? formatTimeForChallenge(challenge.timestamp) : 'pending';
        return $scope.challenges.push(challenge);
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
