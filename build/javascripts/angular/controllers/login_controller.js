(function() {
  lemur.controller('LoginController', [
    '$scope', '$element', '$http', '$timeout', function($scope, $element, $http, $timeout) {
      $scope.error = '';
      return $(function() {
        return $('form').on('submit', function() {
          var email, pass;
          event.preventDefault();
          email = $('[name="email"]').val();
          pass = $('[name="password"]').val();
          return $http.post('/login', JSON.stringify({
            email: email,
            password: pass
          })).success(function(data, status, headers, config) {
            var currentDate, expires, oneWeek;
            if (data.error) {
              return $scope.error = 'NOPE';
            } else {
              oneWeek = 60 * 60 * 24 * 7;
              currentDate = new Date().getTime();
              expires = new Date(currentDate + oneWeek).toUTCString();
              document.cookie = "email=" + data.email + "; expires=" + expires + "; path=/";
              document.cookie = "mystery=" + data.mystery + "; expires=" + expires + "; path=/";
              return $timeout(function() {
                return window.location.replace('/');
              });
            }
          }).error(function(data, status) {
            return $scope.error = 'That may have been my fault.';
          });
        });
      });
    }
  ]);

}).call(this);
