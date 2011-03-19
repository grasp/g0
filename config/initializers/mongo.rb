# To change this template, choose Tools | Templates
# and open the template in the editor.

#MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.connection = Mongo::Connection.new('localhost', 27017, :logger => Rails.logger)
MongoMapper.database = "g0_#{Rails.env}"



