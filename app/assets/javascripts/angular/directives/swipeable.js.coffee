lemur.directive 'swipeable', [
    '$log', ($log) ->
        restrict: 'C'
        link: (scope, elem, attrs) ->
            $(elem).on 'swiperight', ->
                $wrapper = $(this).find('.wrapper')
                leftPos  = $wrapper.position().left
                winWidth = $(window).width()
                pages = 3 - 1

                if Math.abs(leftPos) < winWidth * pages
                    $wrapper.animate(left: "#{leftPos - winWidth}px")
                    scope.$apply -> scope.page += 1

            $(elem).on 'swipeleft', ->
                $wrapper = $(this).find('.wrapper')
                leftPos  = $wrapper.position().left
                winWidth = $(window).width()

                if leftPos < 0
                    $wrapper.animate(left: "#{leftPos + winWidth}px")
                    scope.$apply -> scope.page -= 1

]
