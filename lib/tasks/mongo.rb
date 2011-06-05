# To change this template, choose Tools | Templates
# and open the template in the editor.

$debug=true
$mongo=Mongo::Connection.new('localhost', 27017)
$debug ? $db = $mongo.db('g0_development') : $db = $mongo.db('g0_production')
Mongoid.database = $db
