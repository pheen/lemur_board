(function() {
  lemur.controller('LemurController', [
    '$scope', '$element', '$http', function($scope, $element, $http) {
      return $scope.page = 1;
    }
  ]);

}).call(this);
