G0::Application.routes.draw do

  match '/mail_accounts/index(/:test_mail)'  =>'mail_accounts#index',:as=>:mail_account_index
  match '/mail_accounts/tuiguang((/mode/:mode/way/sent)(/domain/:domain))'  =>'mail_accounts#tuiguang',:as=>:mail_account_tuiguang
  match '/mail_accounts/tuiguang/((/mode/:mode/way/receive)(/domain/:domain))'  =>'mail_accounts#receive',:as=>:mail_account_receive
  resources :mail_accounts

  resources :lib_companies

  resources :feedbacks
  match '/admin/hourscan'  =>'admin#hourscan',:as=>:adminhourscan
  match '/admin/hourscaninfo'  =>'admin#hourscaninfo',:as=>:adminhourscaninfo  
  match '/admin/move'  =>'admin#move',:as=>:adminmove
  match '/admin/moveinfo'  =>'admin#moveinfo',:as=>:adminmoveinfo  
  match '/admin/quzhougrasp'  =>'admin#quzhougrasp',:as=>:adminquzhougrasp
  match '/admin/tf56grasp'  =>'admin#tf56grasp',:as=>:admintf56grasp
  match '/admin/cargo_manage'  =>'admin#cargo_manage',:as=>:admincargo_manage
  match '/admin/stockcargo_manage'  =>'admin#stockcargo_manage' ,:as=>:adminstockcargo_manage
  match '/admin/truck_manage'  =>'admin#truck_manage',:as=>:admintruck_manage
  match '/admin/stocktruck_manage'  =>'admin#stocktruck_manage',:as=>:adminstocktruck_manage
  match '/admin/quote_manage'  =>'admin#quote_manage',:as=>:adminquote_manage
  match '/admin/usercontact_manage'  =>'admin#usercontact_manage',:as=>:adminusercontact_manage
  match '/admin/company_manage  '  =>'admin#company_manage' ,:as=>:admincompany_manage
  match '/admin/get_room_contact' =>'admin#get_room_contact' ,:as=>:admin_get_room_contact
  match '/admin/show_room_contact' =>'admin#show_room_contact' ,:as=>:admin_show_room_contact
  match '/admin/grasp_tf56' =>'admin#grasp_tf56' ,:as=>:admin_grasp_tf56
  match '/admin/grasp_quzhou' =>'admin#grasp_quzhou' ,:as=>:admin_grasp_quzhou
  match '/admin/scan' =>'admin#scan' ,:as=>:admin_scan
  match '/admin/scaninfo' =>'admin#scan_info' ,:as=>:admin_scan_info
  match '/admin/show_cron_mail' =>'admin#show_cron_mail' ,:as=>:admin_show_cron_mail
  match 'admin/daily_trends/day/:day/table/:table(/field/:field/condition/:condition/value/:value)' =>'admin#daily_trends' ,:as=>:admin_daily_trends
  match 'admin/hourly_trends/day/:day/table/:table(/field/:field/condition/:condition/value/:value)' =>'admin#hourly_trends' ,:as=>:admin_daily_trends
  match '/admin/request_log_analysis((/all/:all)(/logfile/:logfile))' =>'admin#request_log_analysis' ,:as=>:admin_request_log_analysis
  match '/admin/show_log(/logfile/:logfile)' =>'admin#show_log' ,:as=>:admin_show_log
  match '/admin/backup_db' =>'admin#backup_db' ,:as=>:admin_backup_db
  get "admin/index"

  resources :citystatistics

  get "quzhou_wuliu/index"
  get "quzhou_wuliu/show"

  match '/scans/uinfoscan'  =>'scans#uinfoscan',:as=>:scanuinfoscan
  match '/scans/expiretimer'  =>'scans#expiretimer',:as=>:scanexpiretimer
  match '/scans/truckexpire'  =>'scans#truckexpire',:as=>:scantruckexpire
  match '/scans/cargoexpire'  =>'scans#cargoexpire',:as=>:scancargoexpire
  match '/scans/scan'  =>'scans#scan',:as=>:scanscan
  match '/scans/scaninfo'  =>'scans#scaninfo',:as=>:scaninfo
  resources :scans

  resources :lstatistics

  resources :ustatistics

  resources :tstatistics

  resources :cstatistics

  get "public/index"
  match '/trucks/quoteinquery/:truck_id' =>'trucks#quoteinquery',:as=>:truckquoteinquery
  match '/cargos/quoteinquery/:cargo_id' =>'cargos#quoteinquery',:as=>:cargoquoteinquery
  match '/trucks/:truck_id/cargos/:cargo_id/inqueries/new'  =>'inqueries#new',:as=>:inquerienew
  match '/trucks/:truck_id/inqueries/truck' =>'inqueries#truck', :as=>:inquerietruck
  match '/cargos/:cargo_id/inqueries/cargo' =>'inqueries#cargo', :as=>:inqueriescargo
  match 'users/:user_id/inqueries/tome/:to' =>'inqueries#index',:as=>:inqueriesto
  match "inqueries/request_chenjiao/:id" =>'inqueries#request_chenjiao',:as=>:inqueriesrequest_chenjiao
  match "inqueries/confirm_chenjiao/:id" =>'inqueries#confirm_chenjiao',:as=>:inqueriesconfirm_chenjiao
  resources :inqueries
  #map.connect '/cargos/search/from/:from/to/:to/page/:page',:controller=>"cargos",:action=>"search"
  match '/cargos/search(/:from/:to(/:page))'  =>'cargos#search',:as=>:cargossearchline
  #match  '/cargos/search'=>'cargos#search',:as=>:cargossearch  
  match '/cargos/:cargo_id/trucks/:truck_id/quotes/new'  =>'quotes#new',:as=>:quotesnew
  match '/cargos/:cargo_id/quotes/cargo' =>'quotes#cargo', :as=>:quotescargo
  match '/trucks/:truck_id/quotes/truck' =>'quotes#truck', :as=>:quotestruck
  match 'users/:user_id/quotes/tome/:to' =>'quotes#index',:as=>:quotesto
  match "quotes/request_chenjiao/:id" =>'quotes#request_chenjiao',:as=>:quotesrequest_chenjiao
  match "quotes/confirm_chenjiao/:id" =>'quotes#confirm_chenjiao',:as=>:quotesconfirm_chenjiao
  resources :quotes

  resources :line_ads

  match 'searches/:user_id/:stype/' =>'searches#new',:as=>:searchespublicnew

  resources :searches

  get "public_main/index"


  match 'users/login' => 'users#login', :as => :userslogin
  match 'cargos/public' =>'cargos#public',:as=>:cargospublic
  match 'trucks/public' =>'trucks#public',:as=>:truckspublic

  match '/trucks/search/:from/:to/:page'  =>'trucks#search',:as=>:truckssearchline
  match '/trucks/request_chenjiao/:id' =>"trucks#request_chenjiao" ,:as=>:trucksrequest_chenjiao
  match '/trucks/index/:status' =>"trucks#index" ,:as=>:truckindexstatus
  #  match  '/trucks/search'=>'trucks#search',:as=>:trucksearch
  match  '/trucks/new'=>'trucks#new',:as=>:trucksnew
  match  '/trucks/create'=>'trucks#create',:as=>:truckscreate
  match '/trucks/show' =>'trucks#show',:as=>:trucksshow
  match '/trucks/list/:id'=>'trucks#index',:as=>:trucksindex
  match '/trucks/:truck_id/match' =>'trucks#match', :as=>:trucksmatch
  resources :trucks do
    resources :inqueries
    resources :quotes
  end
  match '/companies/new/(:who)' =>'companies#new',:as=>:companiesnewwho
  match '/companies/index/:id(/:who)' =>'companies#index',:as=>:companiesindex
  match '/companies/showf/:id' =>'companies#showf',:as=>:companiesshowf
  match '/companies/show/:id/(:who)' =>'companies#show',:as=>:companiesshow
  match '/companies/search' =>'companies#search',:as=>:companiessearch
  match '/companies/create' =>'companies#create',:as=>:companiescreate
  match '/companies/admin' =>'companies#admin',:as=>:companiesadmin
  resources :companies

  match '/stock_trucks/:stock_truck_id/trucks/part' =>'trucks#part', :as=>:truckspart
  match  '/stock_trucks/oper/:id' =>'stock_trucks#oper',:as=>:stock_trucksoper
  match '/stock_trucks/create' =>'stock_trucks#create',:as=>:stock_truckscreate
  resources :stock_trucks do
    resources :trucks
  end

  match '/stock_cargos/:stock_cargo_id/cargos/part' =>'cargos#part', :as=>:cargospart
  match  '/stock_cargos/create' =>'stock_cargos#create', :as=>:stock_cargoscreate

  resources :stock_cargos  do
    resources :cargos
  end

  # match '/cargos/:cargo_id/inqueries/part' =>'inqueries#part', :as=>:inqueries#part
  match 'cargos/request_chenjiao/:id'=>"cargos#request_chenjiao" ,:as=>:cargorequest_chenjiao
  match '/cargos/index/:status' =>"cargos#index" ,:as=>:cargoindexstatus
  match '/cargos/search' =>'cargos#search', :as=>:cargosrootsearch
  match '/cargos/new' =>'cargos#new', :as=>:cargosnew
  match '/cargos/create' =>'cargos#create', :as=>:cargoscreate
  match '/cargos/show' =>'cargos#show', :as=>:cargosshow
  match '/cargos/list/:id' =>'cargos#index', :as=>:cargosindex
  match '/cargos/:cargo_id/match' =>'cargos#match', :as=>:cargosmatch
  match '/cargos/destroy/:id' =>'cargos#destroy', :as=>:cargosdestroy
  
  resources :cargos do
    resources :quotes
    resources :inqueries
  end


  match  '/package_categories/show/:code' =>'package_categories#show',:as=>:package_categoriesshow
  resources :package_categories
  match '/user_contacts/showf/:id'=>'user_contacts#showf' , :as=>:usercontactsshowf
  match '/user_contacts/index/:id/(:who)'=>'user_contacts#index' , :as=>:usercontactsindex
  match '/user_contacts/user/:user_id'=>'user_contacts#show' , :as=>:usercontactsshow
  match '/user_contacts/edit'=>'user_contacts#edit' , :as=>:usercontactsedit
  match '/user_contacts/create' =>'user_contacts#create', :as=>:usercontactscreate
  resources :user_contacts

  match '/cargo_categories/show/:code'=>'cargo_categories#show',:as=>:cargo_categoriesshow
  resources :cargo_categories


  match '/cities/:dir(/:code)'=>'cities#index',:as=>:citiesindex
  resources :cities

  match 'users/login' =>'users#login',:as=>:userslogin
  match 'users/logout' =>'users#logout',:as=>:userslogout
  match 'users/pwreset' =>'users#pwreset',:as=>:userspwreset
  match 'users/authenticate' =>'users#authenticate',:as=>:usersauthenticate
  match '/users/activate/:name/:code' =>'users#activate',:as=>:usersactivate
  match '/users/pw_sent_confirm' =>'users#pw_sent_confirm',:as=>:userspwsentconfirm
  match '/users/pw_reset_request' =>'users#pw_reset_request',:as=>:userspwresetrequest
  match '/users/change_password_confirm/:username/:activate' =>'users#change_password_confirm',:as=>:usersactivate
  resources :users do
    resources :stock_cargos
    resources :stock_trucks
    resources :cargos
    resources :trucks
    resources :quotes
    resources :inqueries
    resources :companies
    resources :searchs
    resources :contact_people
  end



  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "cargos#search"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  match ':controller(/:action(/:id(.:format)))'

end
