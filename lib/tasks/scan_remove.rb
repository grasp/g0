# To change this template, choose Tools | Templates
# and open the template in the editor.

require 'rubygems'
require 'mongo'
require 'logger'
require 'mongoid'

require '/opt/vob/g0/app/models/user.rb'
require '/opt/vob/g0/app/models/cargo.rb'
require '/opt/vob/g0/app/models/truck.rb'
require '/opt/vob/g0/app/models/expired_cargo.rb'
require '/opt/vob/g0/app/models/expired_truck.rb'
require '/opt/vob/g0/app/models/stock_cargo.rb'
require '/opt/vob/g0/app/models/stock_truck.rb'
require '/opt/vob/g0/app/models/ustatistic.rb'
require '/opt/vob/g0/app/models/quote.rb'
require '/opt/vob/g0/app/models/inquery.rb'
require '/opt/vob/g0/app/models/expired_quote.rb'
require '/opt/vob/g0/app/models/expired_inquery.rb'
require '/opt/vob/g0/app/models/scan.rb'
require '/opt/vob/g0/app/models/move.rb'

require '/opt/vob/g0/app/helpers/scans_helper.rb'
require '/opt/vob/g0/lib/tasks/mongo.rb'
include ScansHelper
scan_helper
move_helper

