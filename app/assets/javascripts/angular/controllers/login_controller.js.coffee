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
              oneWeek = 60*60*24*7
              currentDate = new Date().getTime()
              expires = new Date( currentDate + oneWeek).toUTCString() 
              document.cookie = "email=#{data.email}; expires=#{expires}; path=/"
              document.cookie = "mystery=#{data.mystery}; expires=#{expires}; path=/"

              $timeout -> window.location.replace('/')
          .error (data, status) ->
            $scope.error = 'That may have been my fault.'

]
