# coding: utf-8
module ScansHelper

def compare_time_expired(created_time,expired)
unless created_time.nil? || expired.nil?
   current_time=Time.now   
   case expired
    when "0"
     expired_time=Time.parse(created_time.to_s).end_of_day # must have to_s
    when "1"
      expired_time=1.days.since(created_time)
    when "2"
      expired_time=2.days.since(created_time)
    when "3"
      expired_time=3.days.since(created_time)
   else
   #  puts "unknow time"
     expired_time=3.days.since(created_time)
    end
  # if info.from_site=="local"
  #   Rails.logger.info "expired=#{expired},created_time=#{created_time},expired_time=#{expired_time}"
  # end
    if(Time.parse(expired_time.to_s) -current_time <=0)
    #  puts "expired #{created_time}"
      return true
    else
       # puts "not expired"
      return false
    end
else
  return false #keep those illegal ?
end
end

def scan_helper
   expired_truck=0;  expired_cargo=0; start_time=Time.now
   truck_expire_line=Array.new;   cargo_expire_line=Array.new;    truck_scan_start=Time.now
  #first expire the external information
  a=[Truck,Cargo]
  a.each do |records|
     records.where(:status.in=>["正在配货","正在配车"],:from_site.in=>["tf56","quzhou"]).each do |record|
       record.update_attribute("status","超时过期")     if compare_time_expired(record.created_at,record.send_date || "1")==true
     end
  end
a.each do |records|
   records.where(:status.in=>["正在配货","正在配车"],:from_site=>"local").each do |record|
      if compare_time_expired(record.created_at,record.send_date || "1")==true
      record.update_attribute("status","超时过期")
      
        begin
          record.paizhao.blank? #is huo record  ,mongoid will raise exception if no method
          StockCargo.where("cargo_id"=>record.id).each { |stockcargo| stockcargo.inc(:valid_cargo,-1)}
          Quote.where("cargo_id"=>record.id).each { |quote| quote.update_attribute("status","超时过期")}
          Inquery.where("cargo_id"=>record.id).each { |inquery| inquery.update_attribute("status","超时过期")}
          Ustatistic.where(:user_id=>record.user_id).first.inc(:valid_cargo,-1)
        rescue  #is che record
           StockTruck.where("truck_id"=>record.id).each { |stocktruck| stocktruck.inc(:valid_truck,-1)}
           Quote.where("truck_id"=>record.id).each { |quote| quote.update_attribute("status","超时过期")}
           Inquery.where("truck_id"=>record.id).each { |inquery| inquery.update_attribute("status","超时过期")}
           Ustatistic.where(:user_id=>record.user_id).first.inc(:valid_truck,-1)
        end
      end
   end
end

    #update sans statistic
    scan=Hash.new
    #calculate time cost
     end_time=Time.now
    scan[:cost_time]=end_time-start_time
    @scan = Scan.new(scan)
    @scan.save
    # we will do scan work in this action
end
def move_helper
     start_time=Time.now; @move=Move.new;@move.expired_cargo=0;@move.expired_truck=0;@move.expired_quote=0;@move.expired_inquery=0
     a=Hash.new
    a[Truck]=ExpiredTruck;a[Cargo]=ExpiredCargo;a[Quote]=ExpiredQuote;a[Inquery]=ExpiredInquery
    a.each do |a,b|
      a.where(:status=>"超时过期").each do |record|
    #only move those expired 3 months
      if compare_time_expired(record.updated_at,90)==true
      expiredb=b.new
      record.raw_attributes.keys.each do |key|
       expiredb[key[0]]=record[key[0]]
      end
      expiredb.save
      record.destroy
     # puts "record moved!"
      @move.expired_truck+=1
    end
    end
    end

    end_time=Time.now
    @move.cost_time=end_time-start_time

    @move.save
end
end
