formatTimeForChallenge = (dateTime) ->
  if dateTime > new Date
    "#{dateTime.getHours()}:#{dateTime.getMinutes()}"
  else
    dateTime.toLocaleDateString()

lemur.controller 'LemurController', [
  '$scope', '$window', '$element', '$timeout', '$http', '$famous', 'Wormhole',
  ($scope, $window, $element, $timeout, $http, $famous, Wormhole) ->

    Transitionable = $famous['famous/transitions/Transitionable'];
    EventHandler   = $famous['famous/core/EventHandler']

    $scope.opts =
      container:
        properties:
          overflow: 'hidden'
          'z-index': 1
      datepickerContainer:
        properties:
          border: '5px solid rgb(44, 51, 55)'
          overflow: 'hidden'
          'z-index': 1

    $scope.events = {}
    $scope.events.mainScroll           = new EventHandler()
    $scope.events.calendarScroll       = new EventHandler()
    $scope.events.opponentsScroll      = new EventHandler()
    $scope.events.challengeYearScroll  = new EventHandler()
    $scope.events.challengeMonthScroll = new EventHandler()
    $scope.events.challengeDayScroll   = new EventHandler()
    $scope.events.challengeHourScroll  = new EventHandler()
    $scope.events.challengeMinScroll   = new EventHandler()
    $scope.events.challengePerScroll   = new EventHandler()



    $scope.years  = [ 15 .. 16 ]
    $scope.months = [  1 .. 12 ]
    $scope.days   =
      1:  [ 1 .. 31 ]
      2:  [ 1 .. 28 ]
      3:  [ 1 .. 31 ]
      4:  [ 1 .. 30 ]
      5:  [ 1 .. 31 ]
      6:  [ 1 .. 30 ]
      7:  [ 1 .. 31 ]
      8:  [ 1 .. 31 ]
      9:  [ 1 .. 30 ]
      10: [ 1 .. 31 ]
      11: [ 1 .. 30 ]
      12: [ 1 .. 31 ]

    $scope.hours = [ 1 .. 12 ]
    $scope.mins  = [ 0 .. 59 ]
    $scope.pers  = [ 'AM', 'PM' ]

    date = new Date

    $scope.challengeMonth = date.getMonth() + 1

    $scope.challengeYearIndex  =  $scope.years.indexOf(parseInt(date.getFullYear().toString().substr(2,2), 10))
    $scope.challengeMonthIndex =  $scope.months.indexOf(date.getMonth() + 1)
    $scope.challengeDayIndex   =  $scope.days[$scope.challengeMonth].indexOf(date.getDay() + 1)
    $scope.challengeHourIndex  =  $scope.hours.indexOf(if date.getHours() <= 12 then date.getHours() else date.getHours() - 12)
    $scope.challengeMinIndex   =  $scope.mins.indexOf(date.getMinutes())
    $scope.challengePerIndex   =  $scope.pers.indexOf(if date.getHours() <= 12 then 'AM' else 'PM')



    $scope.options =
      mainScrollView:
        direction: 0
        paginated: true
      calendarScrollView:
        direction: 1
      challengeDateScrollView:
        direction: 1
        paginated: true

    $scope.selectOpponent = (opponent) ->
      $scope.challenge.opponent = opponent

    $scope.submitChallenge = ->
      yearIndex  = $famous.find('#year')[0].renderNode._node.getIndex()
      monthIndex = $famous.find('#month')[0].renderNode._node.getIndex()
      dayIndex   = $famous.find('#day')[0].renderNode._node.getIndex()
      hourIndex  = $famous.find('#hour')[0].renderNode._node.getIndex()
      minIndex   = $famous.find('#min')[0].renderNode._node.getIndex()
      perIndex   = $famous.find('#per')[0].renderNode._node.getIndex()

      datetime = new Date(
        "20#{$scope.years[yearIndex]}"
        $scope.months[monthIndex] - 1
        $scope.days[$scope.challengeMonth][dayIndex]
        if $scope.pers[perIndex] is 'AM' then $scope.hours[hourIndex] else $scope.hours[hourIndex] + 12
        $scope.mins[minIndex]
      )

      if datetime.toString() is "Invalid Date"
        $scope.error = 'Invalid Date'
        console.log 'invalid date'
      else if not $scope.challenge.opponent
        $scope.error = 'Missing opponent'
        console.log 'Missing opponent'
      else
        $scope.error = ''

        msg = JSON.stringify
          issueChallenge:
            challenger_email: $scope.currentUser.email
            opponent_email: $scope.challenge.opponent.email
            time: datetime.getTime()

        Wormhole.send(msg)

        $scope.growl = 'Challenge Submitted'
        $scope.growlPosition.set($scope.windowWidth * 0.1, duration: 350, curve: 'easeInOut')

        $timeout ->
          $scope.growlPosition.set(-$scope.growlHeight, duration: 350, curve: 'easeInOut')
        , 1500

    $scope.selectedOpponent = (opponent) ->
      $scope.challenge.opponent == opponent

    $scope.openChallengePane = ->
      $scope.challengePaneActive = !$scope.challengePaneActive

      console.log('hi')
      console.log($scope.challengePaneActive)

      if $scope.challengePaneActive
        $scope.barDynHeight.set([$window.innerWidth, $window.innerHeight], duration: 350, curve: 'easeInOut')
      else
        $scope.barDynHeight.set([$window.innerWidth, $window.innerHeight * 0.07], duration: 350, curve: 'easeInOut')

    $scope.acceptChallenge = (challenge) ->
      index = $scope.challengesToAccept.indexOf(challenge)
      $scope.challengesToAccept.splice(index, 1)
      $scope.challenges.push(challenge)

      msg = JSON.stringify
        acceptChallenge: challenge.id

      Wormhole.send(msg)

      $scope.growl = 'Challenge Accepted'
      $scope.growlPosition.set($scope.windowWidth * 0.1, duration: 350, curve: 'easeInOut')

      $timeout ->
        $scope.growlPosition.set(-$scope.growlHeight, duration: 350, curve: 'easeInOut')
      , 1500

    $scope.challengePaneActive = false
    $scope.challenge = {}

    calcuateHeight = ->
      $scope.windowHeight = $window.innerHeight
      $scope.windowWidth = $window.innerWidth
      $scope.growlHeight = $scope.windowHeight / 10
      $scope.barHeight  = $window.innerHeight * 0.07
      $scope.barDynHeight  = new Transitionable([$scope.windowWidth, $window.innerHeight * 0.07])
      $scope.bodyHeight = $window.innerHeight - $scope.barHeight
      $scope.calendarItemHeight = $window.innerHeight * 0.12
      $scope.profileCalendarHeight = $scope.calendarItemHeight * 5
    calcuateHeight()

    $scope.growlPosition = new Transitionable(-$scope.growlHeight)

    angular.element($window).bind 'resize', ->
      $scope.$apply ->
        calcuateHeight()


    $scope.users = []
    Wormhole.scope = $scope

    Wormhole.current_user = (user) ->
      $scope.currentUser = user

    Wormhole.users = (users) ->
      $scope.users = users
      $scope.opponents = _.omit(users, $scope.currentUser.id)

    Wormhole.challenges = (challenges) ->
      $scope.challenges = []
      $scope.challengesToAccept = []

      for challenge in challenges
        challenge.challenger_id = parseInt(challenge.challenger_id, 10)
        challenge.opponent_id = parseInt(challenge.opponent_id, 10)
        challenge.timestamp = new Date(parseInt(challenge.timestamp, 10))
        challenge.time = if challenge.accepted then formatTimeForChallenge(challenge.timestamp) else 'pending'

        if challenge.opponent_id is parseInt($scope.currentUser.id, 10)
          debugger

        if challenge.opponent_id is parseInt($scope.currentUser.id, 10) and challenge.accepted is false
          $scope.challengesToAccept.push(challenge)
        else
          $scope.challenges.push(challenge)

    Wormhole.new_challenge = (challenge) ->
      challenge.challenger_id = parseInt(challenge.challenger_id, 10)
      challenge.opponent_id = parseInt(challenge.opponent_id, 10)
      challenge.timestamp = new Date(parseInt(challenge.timestamp, 10))
      challenge.accepted = challenge.accepted
      challenge.time = if challenge.accepted then formatTimeForChallenge(challenge.timestamp) else 'pending'

      $scope.challenges.push(challenge)

    $scope.openChallengeForm = (user) ->
      $scope.userToSmite = user.email

    $scope.clearChallenge = ->
      $scope.userToSmite = null

]
