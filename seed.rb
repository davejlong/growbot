require 'couchrest'
require 'date'

db = CouchRest.database!('http://127.0.0.1:5984/metrics')

# loop through 1 month by minute
stop = Date.today.to_time
start = Date.today.prev_month.to_time
