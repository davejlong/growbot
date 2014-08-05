SeriesChart = ($window) ->
  restrict: 'EA'
  scope:
    data: '='
    key: '@'
    height: '@'
  controller: ['$scope', ($scope) ->
    $scope.height = if $scope.height then $scope.height else 500
    @
  ]
  link: (scope, element, attrs) ->
    margin = top: 20, right: 200, bottom: 30, left: 50
    height = scope.height
    height -= margin.top - margin.bottom

    svg = d3.select element[0]
      .append 'svg'
      .style 'width', '100%'
      .attr 'height', height + margin.top + margin.bottom

    window.onresize = -> scope.$apply()
    scope.$watch(
      -> angular.element($window)[0].innerWidth
      -> scope.render(scope.data)
    )

    dataWatcher = (newData) -> scope.render newData
    scope.$watch 'data', dataWatcher, true

    scope.render = (data) ->
      svg.selectAll('*').remove()
      return if !data
      width = d3.select(element[0]).node().offsetWidth
      width -= margin.left - margin.right

      x = d3.time.scale().range [0, width]
      y = d3.scale.linear().range [height, 0]

      color = d3.scale.category10().domain ['light', 'moisture']

      xAxis = d3.svg.axis().scale(x).orient 'bottom'
      yAxis = d3.svg.axis().scale(y).orient 'left'

      lightLine = d3.svg.line()
        .interpolate 'basis'
        .x (d) -> x(d[scope.key])
        .y (d) -> y(d.light)
      moistureLine = d3.svg.line()
        .interpolate 'basis'
        .x (d) -> x(d[scope.key])
        .y (d) -> y(d.moisture)

      container = svg
        .attr 'width', width + margin.left + margin.right
        .attr 'height', height + margin.top + margin.bottom
        .append 'g'
        .attr 'transform', "translate(#{margin.left}, #{margin.top})"

      x.domain(d3.extent data, (d) -> d[scope.key])

      lightExtent = d3.extent data, (d) -> d.light
      moistureExtent = d3.extent data, (d) -> d.moisture
      yMin = d3.min [ lightExtent[0], moistureExtent[0] ]
      yMax = d3.max [ lightExtent[1], moistureExtent[1] ]
      y.domain([yMin, yMax])

      container.append 'g'
        .attr 'class', 'x axis'
        .attr 'transform', "translate(0, #{height})"
        .call xAxis
      container.append 'g'
        .attr 'class', 'y axis'
        .call yAxis

      container.append 'path'
        .datum data
        .attr 'class', 'line'
        .style 'stroke', color('light')
        .attr 'd', lightLine
      container.append 'path'
        .datum data
        .attr 'class', 'line'
        .style 'stroke', color('moisture')
        .attr 'd', moistureLine

Series = ->


angular.module 'growbot.directives', []
  .directive 'seriesChart', ['$window', SeriesChart]
  #.directive 'series', [Series]
