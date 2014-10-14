lemur.controller 'LoginController', [
  '$scope', '$element', '$http', '$timeout'
  ($scope, $element, $http, $timeout) ->
    $scope.error = ''

    $ ->
      $('form').on 'submit', ->
        event.preventDefault()
        email = $('[name="email"]').val()
        pass  = $('[name="password"]').val()

        $http.post('/login', JSON.stringify( email: email, password: pass ))
          .success (data, status, headers, config) ->
            if data.error
              $scope.error = 'NOPE'
            else
              document.cookie = "email=#{data.email}; expires=Fri, 31 Oct 2014 20:00:00 UTC; path=/"
              document.cookie = "mystery=#{data.mystery}; expires=Fri, 31 Oct 2014 20:00:00 UTC; path=/"

              $timeout -> window.location.replace('/')
          .error (data, status) ->
            $scope.error = 'That may have been my fault.'

]
