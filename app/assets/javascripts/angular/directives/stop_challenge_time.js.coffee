lemur.directive 'stopChallengeTime', [
    '$log', ($log) ->
        scope: true
        restrict: 'C'
        link: (scope, elem, attrs) ->
            scope.years   = [15..17]
            scope.months  = [1..12]
            scope.days    = [1..31]
            scope.hours   = [1..12]
            scope.mins    = [1..59]
            scope.periods = ['am', 'pm']



]
