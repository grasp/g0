 # coding: utf-8
module CargosHelper
  def get_cargo_info_from_params(params)

  params[:cargo][:user_id]=session[:user_id]

    begin
      cargo = Cargo.create!(params[:cargo])
    rescue
      puts "cargo创建失败"
      return nil
    end
    
    puts "cargo创建成功"
      return cargo
  end

  def update_cargo_info_from_params(params)


    if  @cargo
      @cargo.update_attributes( params[:cargo])
      return @cargo
    else
      return nil
    end

 

  end




end
