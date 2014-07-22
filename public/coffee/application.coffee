@growbot = angular.module 'growbot', ['growbot.directives']

@growbot.controller 'MainController', [ ->
  @title = "Growbot"
  @data = [
    { name: 'Greg', score: 98 }
    { name: 'Ari', score: 96 }
    { name: 'Q', score: 75 }
    { name: 'Loser', score: 48 }
  ]
  @
]
