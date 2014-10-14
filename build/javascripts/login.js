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
            if (data.error) {
              return $scope.error = 'NOPE';
            } else {
              document.cookie = "email=" + data.email + "; expires=Fri, 31 Oct 2014 20:00:00 UTC; path=/";
              document.cookie = "mystery=" + data.mystery + "; expires=Fri, 31 Oct 2014 20:00:00 UTC; path=/";
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
