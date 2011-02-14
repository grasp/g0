# To change this template, choose Tools | Templates
# and open the template in the editor.

MongoMapper.connection = Mongo::Connection.new('localhost', 27017)
MongoMapper.database = "g0_#{Rails.env}"

if Tf56grasp.count==0
   puts "initialize for soku grasp tf56"
  Tf56grasp.create(:diff_che=>0,:diff_huo=>0,:total_che=>0,:total_huo=>0,:cycle_che=>0,:cycle_huo=>0)
end
if Quzhougrasp.count==0
  puts "initialize for soku grasp quzhou"
  Quzhougrasp.create(:diff_che=>0,:diff_huo=>0,:total_che=>0,:total_huo=>0,:cycle_che=>0,:cycle_huo=>0)
end