# To change this template, choose Tools | Templates
# and open the template in the editor.

if ARGF.argv[0]=="development"
$debug=true
else
  $debug=false
end
#puts "$debug=#{$debug}"

$mongo=Mongo::Connection.new('localhost', 27017)
$debug ? $db = $mongo.db('g0_development') : $db = $mongo.db('g0_production')
Mongoid.database = $db
