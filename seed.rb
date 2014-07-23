require 'couchrest'
require 'date'

db = CouchRest.database!('http://127.0.0.1:5984/metrics')

puts "Dumping database."
db.all_docs['rows'].each do |doc|
  db.get(doc['id']).destroy
end

print "Importing from log."
lines = File.open('growbot_tracking.access.log', 'r').readlines
lines.each do |line|
  # time=1406056587.480 light=331
  doc = {}
  l = line.split " "
  l.each do |m|
    e = m.split "="
    if e.first.eql? 'time'
      doc['time'] = Time.at(e.last.to_i)
    else
      doc[e.first] = e.last
    end
  end
  db.save_doc doc
  print "."
end
puts ""
puts "All done."
