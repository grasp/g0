 # coding: utf-8
module TrucksHelper
  def get_truck_info_from_params(params)

  params[:truck][:user_id]=session[:user_id]

  begin
  @truck = Truck.create!(params[:truck])
  rescue
    raise
    return nil
  end
   return @truck
end

  def update_truck_info_from_params(params)

    if  @truck
       @truck.update_attributes( params[:truck])
      return @truck
    else
      return nil
    end

  end



end
