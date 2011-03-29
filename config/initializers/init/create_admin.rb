# To change this template, choose Tools | Templates
# and open the template in the editor.
# 
#is this duplicated with mongo.rb?


#@admin=User.where(:name=>"admin").first

if @admin.blank?
 # puts "prepare to create admin"
 # @admin=User.new
  salt= @admin.object_id.to_s+rand.to_s
  password="grasp56#"
 # hashed_password=User.encrypted_password(password, salt)  
 # puts "  hashed_password=#{  hashed_password},salt=#{salt},password=#{password}"
 # User.create(:name=>"admin",:admin=>true,:hashed_password=>hashed_password,
 #               :status=>"actived",:email=>"w22812@motorola.com",:salt=>salt)
 # puts "create admin" if result
else
  puts "admin alread created"
end
