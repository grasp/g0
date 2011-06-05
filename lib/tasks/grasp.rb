# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'rubygems'
require 'mechanize'
require 'mongo'
require 'logger'
require 'mongoid'
require '/opt/vob/g0/app/helpers/quzhougrasp_helper.rb'
require '/opt/vob/g0/app/helpers/tf56grasp_helper.rb'

require '/opt/vob/g0/app/models/user.rb'
require '/opt/vob/g0/app/models/cargo.rb'
require '/opt/vob/g0/app/models/truck.rb'
require '/opt/vob/g0/app/models/grasp_record.rb'
require '/opt/vob/g0/app/models/room_contact.rb'
require '/opt/vob/g0/config/initializers/init/city_dic.rb'
require '/opt/vob/g0/config/initializers/init/city_load.rb'
require '/opt/vob/g0/lib/tasks/mongo.rb'


include QuzhougraspHelper
include Tf56graspHelper


get_quzhou_grasps
get_tf56_grasps
