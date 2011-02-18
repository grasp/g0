# To change this template, choose Tools | Templates
# and open the template in the editor.

#MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :logger => Rails.logger)
MongoMapper.database = "g0_#{Rails.env}"


if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect_to_master if forked
   end
end
