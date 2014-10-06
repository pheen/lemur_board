(function() {
  lemur.directive('swipeable', [
    '$log', function($log) {
      return {
        restrict: 'C',
        link: function(scope, elem, attrs) {
          scope.page = 1;
          $(elem).on('swiperight', function() {
            var $wrapper, leftPos, pages, winWidth;
            $wrapper = $(this).find('.wrapper');
            leftPos = $wrapper.position().left;
            winWidth = $(window).width();
            pages = 3 - 1;
            if (Math.abs(leftPos) < winWidth * pages) {
              $wrapper.animate({
                left: "" + (leftPos - winWidth) + "px"
              });
              return scope.$apply(function() {
                return scope.page += 1;
              });
            }
          });
          return $(elem).on('swipeleft', function() {
            var $wrapper, leftPos, winWidth;
            $wrapper = $(this).find('.wrapper');
            leftPos = $wrapper.position().left;
            winWidth = $(window).width();
            if (leftPos < 0) {
              $wrapper.animate({
                left: "" + (leftPos + winWidth) + "px"
              });
              return scope.$apply(function() {
                return scope.page -= 1;
              });
            }
          });
        }
      };
    }
  ]);

}).call(this);
