ExamApp::Application.routes.draw do

  resources :users do
    collection do
      get "get_proof_code"
    end
  end
  resources :sessions 
  resources :questions

  post "/questions/create"

  match '/signout'=> 'sessions#destroy'
  resources :pages do
    collection do
      get "create_step_one"
      get "create_step_two"
      get "edit"
      get "create_exam_one"
      get "create_exam_two"
      get "create_exam_three"
      get "exam_list"
      get "show_exam"
      get "edit_exam_base"
      get "edit_exam_users"
      get "edit_exam_raters"
    end
  end
  resources :back
  resources :papers do
    collection do
      get "new_step_one"
      post "create_step_one"
      post  "search"
      post "create_exam_one"
      post "create_exam_two"
      post "create_exam_three"
      post "exam_list"
      post "create_step_two"
       get "new_exam_one"
       post :delete_all
    end
    member do
      get "new_exam_three"
      get "new_exam_two"
      get "new_exam_one"
      get "new_step_two"
      post "change_info"
       
    end
  end
    match '/new_exam_one'=>'papers#new_exam_one'
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

 



  root :to => "sessions#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
 
