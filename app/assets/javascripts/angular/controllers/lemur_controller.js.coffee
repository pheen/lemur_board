lemur.controller 'LemurController', [
  '$scope', '$window', '$element', '$http', '$famous', 'Wormhole',
  ($scope, $window, $element, $http, $famous, Wormhole) ->

    calcuateHeight = ->
      $scope.windowHeight = $window.innerHeight
      $scope.barHeight  = $window.innerHeight * 0.07
      $scope.bodyHeight = $window.innerHeight - $scope.barHeight
      $scope.calendarItemHeight = $window.innerHeight * 0.08
      $scope.profileCalendarHeight = $scope.calendarItemHeight * 5
    calcuateHeight()

    angular.element($window).bind 'resize', ->
      $scope.$apply ->
        calcuateHeight()


    EventHandler = $famous['famous/core/EventHandler']
    $scope.mainScrollHandler = new EventHandler()
    $scope.profileScrollHandler = new EventHandler()
    $scope.calendarScrollHandler = new EventHandler()

    $scope.options =
      mainScrollView:
        direction: 0
        paginated: true
      calendarScrollView:
        direction: 1





    $scope.users = []
    Wormhole.scope = $scope

    Wormhole.current_user = (user) ->
      $scope.currentUser = user

    Wormhole.users = (users) ->
      $scope.users = users
      $scope.opponents = _.omit(users, $scope.currentUser.id)

    Wormhole.challenges = (challenges) ->
      for challenge in challenges
        challenge.challenger_id = parseInt(challenge.challenger_id, 10)
        challenge.opponent_id = parseInt(challenge.opponent_id, 10)
        challenge.timestamp = new Date(parseInt(challenge.timestamp, 10) * 1000)
        challenge.time = if challenge.accepted then challenge.timestamp else 'pending'

      $scope.challenges = challenges

    Wormhole.new_challenge = (challenge) ->
      challenge.challenger_id = parseInt(challenge.challenger_id, 10)
      challenge.opponent_id = parseInt(challenge.opponent_idp, 10)
      challenge.timestamp = new Date(parseInt(challenge.timestamp, 10) * 1000)

      $scope.challenges.push(challenge)

    $scope.sendChallenge = ->
      msg = JSON.stringify
        issueChallenge:
          challenger_email: $scope.currentUser.emai
          opponent_email: $scope.userToSmite
          time: $scope.challengeStartTime
      Wormhole.send(msg)

    $scope.openChallengeForm = (user) ->
      $scope.userToSmite = user.email

    $scope.clearChallenge = ->
      $scope.userToSmite = null

    debugger

]
