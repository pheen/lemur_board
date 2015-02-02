(function() {
  lemur.directive('stopChallengeTime', [
    '$log', function($log) {
      return {
        scope: true,
        restrict: 'C',
        link: function(scope, elem, attrs) {
          var _i, _j, _results, _results1;
          scope.years = [15, 16, 17];
          scope.months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
          scope.days = (function() {
            _results = [];
            for (_i = 1; _i <= 31; _i++){ _results.push(_i); }
            return _results;
          }).apply(this);
          scope.hours = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
          scope.mins = (function() {
            _results1 = [];
            for (_j = 1; _j <= 59; _j++){ _results1.push(_j); }
            return _results1;
          }).apply(this);
          return scope.periods = ['am', 'pm'];
        }
      };
    }
  ]);

}).call(this);
