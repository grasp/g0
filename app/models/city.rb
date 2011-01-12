class City < ActiveRecord::Base
 validates_uniqueness_of :code
 has_ancestry :cache_depth => true

  def self.get_province_code_by_code(code)
    code[0..1]+"0000000000"
  end
  
  def get_all_region_code(code)

  end

def self.get_region_city_by_code(code)

city=City.find_by_code(code)

@region_list=Hash.new
@city_list=Hash.new
ret=Array.new

  puts "get_region_city_by_code get code=#{code}"

if code[4..5].to_i>0 # is a city id
 city.siblings.each do |key|
 @city_list.store(key.code,key.name)
 end
 city.parent.siblings.each do |key|
   @region_list.store(key.code,key.name)
 end

elsif code[2..3].to_i>0 #is a region id
 city.siblings.each do |key|
 @region_list.store(key.code,key.name)
 end

 city.children.each do |key|
   @city_list.store(key.code,key.name)
 end
 
 else
  #is a province id

 i=0

 city.children.each do |key|
   @region_list.store(key.code,key.name)
    if i==0
   region=City.find_by_code(key.code)
   region.children.each do |city_key|
    @city_list.store(city_key.code,city_key.name)
   end
  end
  i+=1

 end
end
ret[0]=@region_list
ret[1]=@city_list
ret
end

def self.get_full_name_by_code(code)
 city=City.find_by_code(code)  
 if code[4..5].to_i>0 # is a city id
   city.parent.parent.name+city.parent.name+city.name
elsif code[2..3].to_i>0 #is a region id
  city.parent.name+city.name
 else
  #is a province id
  city.name
 end
end
end
