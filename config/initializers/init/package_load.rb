# coding: utf-8
# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'iconv'

$KCODE="U"
$package_category_one=Hash.new
$package_category_two=Hash.new
$package_category=Hash.new

def load_package_category_to_hash
  filename=File.dirname(__FILE__)+File::SEPARATOR+"package_category.txt"
  open(filename).each do |line|
    line=line.force_encoding("utf-8")

    if not line.nil?
      puts "line=#{line}"
      code= line.match(/^\d\w+/)
      if not code.nil?

        code=code.to_s
        code.chomp!
        code.strip!
        #puts "code=#{code}"
        #notes , the last line need a enter
        name=line.match(/\W+/)
        name=name.to_s
        name.chomp!
        name.strip!
        #puts "name=#{name}"
        puts "code=#{code},name=#{name}"
        $package_category.store(code,name)
      end
    end
  end
end

def load_into_root_node
  rootnode=PackageCategory.create! :name => "包装分类",:code => "0000" if PackageCategory.find_by_name( "包装分类").nil?
end


def load_package_to_database
  load_package_category_to_hash
  load_into_root_node
  rootnode=PackageCategory.find_by_name( "包装分类")
  $package_category.each do |code,name|
    if code.match("000")  and  not code.nil?
      category=PackageCategory.find_by_code( code)
      PackageCategory.create! :name => name,:code => code,:parent =>rootnode if category.nil?
    else
      parenet_code=code[0]+"000"
      parent_node=PackageCategory.find_by_code( parenet_code)
      PackageCategory.create! :name => name,:code => code,:parent =>parent_node
    end
  end
end

def get_level_one_hash
  rootnode=PackageCategory.find_by_name( "包装分类")
  rootnode.children.each do |category|
    $package_category_one.store(category.code,category.name)
  end
end

def get_level_two_hash
  rootnode=PackageCategory.find_by_name( "包装分类")
  rootnode.children.each do |level_one_category|
    level_two_hash=Hash.new
    level_one_category.children.each do |level_two_category|
      level_two_hash.store(level_two_category.code,level_two_category.name)
    end
    $package_category_two.store(level_one_category.code,level_two_hash)
    puts "add code=#{level_one_category.code}"
  end
end

has_migrated=false;
begin
  if ActiveRecord::Base.connection.tables.include?('package_categories')
    has_migrated=true
    puts "package category table alreay migrated"
  else
    has_migrated=false
  end
rescue
  has_migrated=false;
  puts "has not migrationed yet "
end

if(has_migrated==true)
  if(PackageCategory.count<80)
    load_package_to_database
    puts "load package category into database completed"
  end
 
  #load package into local hash
  get_level_one_hash
  get_level_two_hash
end




