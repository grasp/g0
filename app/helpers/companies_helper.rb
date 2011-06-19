 # coding: utf-8
module CompaniesHelper
  def get_company_from_params(params)  

    params[:company][:fix_phone]=params[:quhao]+"-"+ params[:company][:fix_phone]

    @user_id=session[:user_id]
    @user_name=session[:user_id]
     params[:company][:user_id]=@user_id

    @company = Company.create!( params[:company])
    @company.user.company_id= @company.id

    if   @company
      puts "success created"
      return true
    else
      return false
    end
  end
 def update_company(params)

    @user_id=session[:user_id]

    if @company[:user_id]!=@user_id
      flash[:notice]="你不是该信息创建者不能编辑"
      return nil
    end

    if @company
        params[:company][:fix_phone]=params[:quhao]+"-"+ params[:company][:fix_phone]
        @company.update_attributes!(params[:company])
       return  @company
    else
     flash[:notice]="该公司不存在"
      return nil
    end

 end
end
