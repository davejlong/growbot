@growbot = angular.module 'growbot', ['growbot.directives']

@growbot.factory 'GrowbotApi', ['$http', ($http) ->
  sort = (a, b) ->
    if a.time < b.time then -1
    else if a.time > b.time then 1
    else 0
  map = (metric) -> metric.time = new Date metric.time; metric

  callbacks = []

  {
    metrics: []
    load: ->
      $http.get('http://localhost:5100')
        .success (data) =>
          @metrics = data.map(map).sort(sort)
          @notifyCallbacks()
    registerCallback: (callback) -> callbacks.push callback
    notifyCallbacks: -> angular.forEach callbacks, (callback) -> callback()
  }
]

@growbot.controller 'MainController', ['GrowbotApi', (GrowbotApi) ->
  GrowbotApi.registerCallback => @metrics = GrowbotApi.metrics
  GrowbotApi.load()

  @metrics = GrowbotApi.metrics

  @
]
