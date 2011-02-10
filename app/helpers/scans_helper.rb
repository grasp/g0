module ScansHelper

def compare_time_expired(created_time,expired)
unless created_time.nil? || expired.nil?
   current_time=Time.now
   
   case expired
    when "1"
      expired_time=1.days.since(created_time)
    when "2"
      expired_time=2.days.since(created_time)
    when "3"
      expired_time=2.days.since(created_time)
   else
     puts "unknow time"
     expired_time=10.days.since(created_time)
    end

    if(Time.parse(expired_time.to_s) -current_time <=0)
      puts "expired"
      return true
    else
       # puts "not expired"
      return false
    end
else
  return false #keep those illegal ?
end
  end
end
