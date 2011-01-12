# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'iconv'

$KCODE="U"
   
  $cargo_category_one=Hash.new
  $cargo_category_two=Hash.new
  $cargo_category_three=Hash.new
  $cargo_category=Hash.new

def load_cargo_category_to_hash

  filename=File.dirname(__FILE__)+File::SEPARATOR+"cargo_category.txt"
  open(filename).each do |line|
  line=line.force_encoding("utf-8")
# line=line.chomp!
#  line=Iconv.conv("utf-8","GBK",line)
  code= line.match(/\d+/)
  code=code.to_s
  #notes , the last line need a enter
  name=line.match(/\s.*\n/)

  name=name.to_s.chomp! 
  $cargo_category.store(code,name) unless code.nil?

  end

end

def load_into_root_node
  rootnode=CargoCategory.create! :name => "全部分类",:code => "000000" if CargoCategory.find_by_name( "全部分类").nil?
end

 def load_category_to_database
    load_into_root_node
    rootnode=CargoCategory.find_by_name( "全部分类")
    $cargo_category.each do |code,name|
     if(code.match(/\d\d0000/))
         category=CargoCategory.find_by_code( code)
         CargoCategory.create! :name => name,:code => code,:parent =>rootnode if category.nil?
     elsif(code.match(/\d\d\d\d00/))
      parent_code=code[0,2]+"0000"
      parent_node=CargoCategory.find_by_code( parent_code)
       category=CargoCategory.find_by_code( code)
       CargoCategory.create! :name => name,:code => code,:parent =>parent_node if category.nil?
    else
      parent_code=code[0,4]+"00"
      parent_node=CargoCategory.find_by_code( parent_code)
       category=CargoCategory.find_by_code( code)
       CargoCategory.create! :name => name,:code => code,:parent =>parent_node if category.nil?
    end
 end
   puts "cargo category load into database finished"
 end
 

   
 def get_level_one_hash
   rootnode=CargoCategory.find_by_name( "全部分类")
   rootnode.children.each do |category|
     $cargo_category_one.store(category.code,category.name)
   end
 end
def get_level_two_hash
   rootnode=CargoCategory.find_by_name( "全部分类")
   rootnode.children.each do |level_one_category|
   level_two_hash=Hash.new
      level_one_category.children.each do |level_two_category|
        level_three_hash=Hash.new
      level_two_hash.store(level_two_category.code,level_two_category.name)
      level_two_category.children.each do |level_three_category|
        level_three_hash.store(level_three_category.code,level_three_category.name)
      end
      $cargo_category_three.store(level_two_category.code,level_three_hash)
   end
   $cargo_category_two.store(level_one_category.code,level_two_hash)
   end
 end

has_migrated=false;
begin
 if ActiveRecord::Base.connection.tables.include?('cargo_categories')
has_migrated=true
 else
   has_migrated=false
 end
rescue
  has_migrated=false;
  puts "not migration"
end

if(has_migrated==true)
   if(CargoCategory.count<230)
     load_cargo_category_to_hash
     load_category_to_database
   end

   get_level_one_hash
   get_level_two_hash
   load_cargo_category_to_hash   

end

