angular.module 'growbot.directives', []
  .directive 'barchart', ['$window', ($window) ->
    {
      restrict: 'EA'
      scope:
        data: '='
      link: (scope, element, attrs) ->
        margin = parseInt(attrs.margin) or 20
        barHeight = parseInt(attrs.barHeight) or 20
        barPadding = parseInt(attrs.barPadding) or 5

        svg = d3.select element[0]
          .append 'svg'
          .style 'width', '100%'
        window.onresize = -> scope.$apply()

        scope.$watch(
          -> angular.element($window)[0].innerWidth
          -> scope.render(scope.data)
        )

        scope.$watch 'data',
          (newData) -> scope.render newData
          true

        scope.render = (data) ->
          svg.selectAll('*').remove()
          return if !data
          width = d3.select(element[0]).node().offsetWidth - margin
          height = scope.data.length * (barHeight + barPadding)
          color = d3.scale.category20()
          xScale = d3.scale.linear()
            .domain [0, d3.max(data, (d) -> d.light)]
            .range [0, width]

          svg.attr 'height', height
          dataEntered = svg.selectAll 'rect'
            .data(data).enter()
          dataEntered.append 'rect'
            .attr 'height', barHeight
            .attr 'width', 140
            .attr 'x', Math.round(margin/2)
            .attr 'y', (d, i) -> i * (barHeight + barPadding)
            .attr 'fill', (d) -> color(d.light)
            .transition().duration(1000)
            .attr 'width', (d) -> xScale(d.light)
          dataEntered.append 'text'
            .attr 'fill', '#fff'
            .attr 'y', (d, i) -> i * (barHeight + barPadding) + 15
            .attr 'x', 15
            .text (d) -> "#{d.time} (light: #{d.light})"
    }
  ]
