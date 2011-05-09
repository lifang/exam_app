ExamApp::Application.routes.draw do

  resources :users do
    collection do
      get "get_proof_code", "get_register_code"
    end
  end
  resources :sessions 
  resources :questions

  post "/questions/edit"
  post "/questions/create"
  match '/signout'=> 'sessions#destroy'
  resources :pages do
    collection do
      get "create_step_one", "create_step_two", "edit", "create_exam_one", "create_exam_two", "create_exam_three",
        "exam_list", "show_exam", "edit_exam_base", "edit_exam_users", "edit_exam_raters", "setting",
        "result_list", "my_exam_list", "exam_results", "result_list", "show_result", "my_results", "answer_paper"
      get "rater_login", "paper_list", "rate_paper"
      get "exam_query_login", "my_results_simple", "user_exams"
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
      get "new_exam_two"
    end
    member do
      get "new_exam_three"
      get "new_exam_two"
      get "new_exam_one"
      get "new_step_two"
      post "change_info"
      post :delete_all
    end
  end
  match '/new_exam_one'=>'papers#new_exam_one'
  match '/delete_all'=>'papers#index'
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
 
