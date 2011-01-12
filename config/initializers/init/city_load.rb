# coding: utf-8 
## To change this template, choose Tools | Templates
# and open the template in the editor.
require 'active_record'
require 'ancestry'
require 'iconv'

$KCODE="U"

def process_to_level_4
  town_list=Hash.new
  count=0
  value1="（虚拟编码）".encode("GBK")
  value2="办事处".encode("GBK")
  value3="管理委员会".encode("GBK")
  value4=" ★".encode("GBK")

  exclude_value1="民政局".encode("GBK")
  exclude_value2="民政所".encode("GBK")
  exclude_value3="民政处".encode("GBK")

  
  open('code.txt').each do |line|
    name= line.split(',')
    if name[0].match(/\d+000000$/)
      name[1].delete!(value1) if name[1].match(value1)
      name[1].delete!(value2) if name[1].match(value2)
      name[1].delete!(value3) if name[1].match(value3)
      name[1].delete!(value4) if name[1].match(value4)
      name[1].strip!
      
      town_list[name[0]]=name[1]+"\n"  if not (name[1].match(exclude_value1) ||
          name[1].match(exclude_value2) ||
          name[1].match(exclude_value3) )
      # name[1].size <6 )
      count+=1
    end
  end

	out = File.new("code2.txt","w")
  town_list.each do |key,value|
    out << "#{key},#{value}"
  end
  out.close
  puts "结束城市基础数据文本的第一次加工处理"

end

def activerecord_connect
  ActiveRecord::Base.establish_connection(
    :adapter => "mysql" ,
    :host  =>"localhost",
    :database => "g1_development" ,
    :username => "root" , # defaults to 'root'
    :password => "",
    :encoding => "utf8"
  )
  ActiveRecord::Base.connection.execute 'SET NAMES UTF8'
end

def write_into_province

  #City.activerecord_connect if  not ActiveRecord::Base.connected?

  # Wrtie into and load the root node
  if City.find_by_name( "中国").nil?
    rootnode=City.create! :name => "中国",:code => "100000000000" unless City.find_by_name( "中国")
  else
    rootnode=City.find_by_name( "中国")
  end



  #first write into all province name
  filename=File.dirname(__FILE__)+File::SEPARATOR+"code3.txt"
  open(filename).each do |line|
    #line=line.encode("utf-8")
    line=Iconv.conv("utf-8","GB2312",line)
    name= line.split(',')
    if name[0].match(/\d\d0000000000$/)
      name[1]=name[1].chomp!

      city=City.find_by_code(name[0])

      if city.nil?
        puts "writing into #{name[1]}"
      end
      rootnode.children.create! :name => name[1],:code => name[0]  if city.nil?
      #  City.create! :name => name[1],:code => name[0],:parent => rootnode if city.nil?
    end
  end

end

def write_into_region
  # City.activerecord_connect if  not ActiveRecord::Base.connected?

  #first write into all region name
  filename=File.dirname(__FILE__)+File::SEPARATOR+"code3.txt"
  open(filename).each do |line|
    # line=line.encode("utf-8")
    line=Iconv.conv("utf-8","GB2312",line)

    name= line.split(',')
   
    if name[0].match(/\d\d\d\d00000000$/)  and (not name[0].match(/\d\d0000000000$/))
      #  puts name[0]+name[1]

      name[1]=name[1].chomp!
      parent_code=name[0].sub(/\d\d00000000$/,"")
   
      parent_code=parent_code+"0000000000"
   
      parent_node=City.find_by_code(parent_code)

      if not (parent_node.nil?)
        # puts "parent_code=#{parent_code}=#{parent_node.name}"
      else
        puts "parent code is nil parent_code=#{parent_code} for #{name[0]}"
        raise "parent code error"
      end

      city=City.find_by_code(name[0])

      if city.nil?
        puts "writing into #{name[1]} parentnode= #{parent_code}"
      end
      parent_node.children.create! :name => name[1],:code => name[0]  if city.nil?
      # City.create! :name => name[1],:code => name[0],:parent => parent_node if city.nil?
    end
  end

end

def write_into_city
  filename=File.dirname(__FILE__)+File::SEPARATOR+"code3.txt"
  open(filename).each do |line|
    # line=line.encode("utf-8")
    line=Iconv.conv("utf-8","GB2312",line)
    
    name= line.split(',')
    if name[0].match(/\d\d\d\d\d\d000000$/)  and (not name[0].match(/\d\d0000000000$/)) and (not name[0].match(/\d\d\d\d00000000$/))
      # puts name[0]+name[1]
      name[1]=name[1].chomp!
      parent_code=name[0].sub(/\d\d000000$/,"")
      parent_code=parent_code+"00000000"
      parent_node=City.find_by_code(parent_code)

      if not (parent_node.nil?)
        #  puts "parent_code=#{parent_code}=#{parent_node.name}"
      else
        puts "parent code is nil parent_code=#{parent_code} for #{name[0]}"
        raise "parent code error"
      end

      city=City.find_by_code(name[0])

      if city.nil?
        puts "writing into #{name[1]} parentnode= #{parent_code}"
      end
      parent_node.children.create! :name => name[1],:code => name[0]  if city.nil?
      #  City.create! :name => name[1],:code => name[0],:parent => parent_node if city.nil?
    end
  end
end

has_migrated=false;
begin
  if ActiveRecord::Base.connection.tables.include?('cities')
    has_migrated=true
  else
    has_migrated=false
  end
rescue
  has_migrated=false;
end
if(has_migrated==true)
  if(City.count <3300)

    write_into_province
    write_into_region
    write_into_city

    puts "load the city data into table write complete"

  end

  rootnode=City.find_by_name("中国")
  
  all_province=rootnode.subtree(:to_depth =>1)

  $province=Hash.new
  $province1=Hash.new
  $province2=Hash.new

 if all_province.size >0
all_province.each do |province|
  $province.store(province.code,province.name)
end
  $province.delete(rootnode.code)
end
middle=$province.size/2
i=0;

$province.each do |key,value|
  if i<middle
    $province1.store(key,value)
  else
     $province2.store(key,value)
  end
  i=i+1
end

# generate a province hash for list
#$province["100000000000"]="全国"
$raw_province_array=[[110000000000,120000000000],
[130000000000,140000000000],
[210000000000,150000000000],
[220000000000,230000000000],
[320000000000,310000000000],
[330000000000,340000000000],
[350000000000,360000000000],
[370000000000,410000000000],
[420000000000,430000000000],
[440000000000,450000000000],
[460000000000,500000000000],
[510000000000,520000000000],
[530000000000,540000000000],
[610000000000,620000000000],
[630000000000,640000000000],
[650000000000],
]



end


