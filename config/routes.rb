ExamApp::Application.routes.draw do

  match '/signout'=> 'sessions#destroy'

 resources :item_pools do
   collection do
     get :paper_item
   end

 end

  namespace :user do
    resources :examinations do
      member do
        post "save_result", "five_min_save"
        get "do_exam"
      end
      collection do
        get "error_page"
      end
    end
    resources :exam_users do
      collection do
        get "session_new", "affiremed_false","affiremed_success"
        post "exam_session","search"
        get "search_list"
      end
      member do
        get "my_results"
        get "exam_user_affiremed"
        post "edit_score","edit_name"
      end
    end
    resources :collections do
      collection do
        post "search"
      end
    end
  end
  
  resources :users do
    collection do
      get "roles_manage"
      get "get_proof_code", "get_register_code", "re_active", "active_success", "active_false"
      post "add_role","load_set_right","set_right","load_edit_role","edit_role","load_set_role","set_role","index_search"
    end
    member do
      get "active", "user_active"
      post "update_info"
    end
  end
  namespace :rater do
    resources :exam_raters do
      collection do
        get "session","check_paper"
      end
      member do
        post "edit_value"
        get "rater_session","get_score"
        post "rater_login","over_answer"
        get "reader_papers","answer_paper"
      end
    end
  end
  resources :results do
    collection do
      post "search"
      get "search_list"
    end
  end
  resources :sessions do
    collection do
      get "get_code"
      post "user_code"
    end
    member do
      get "new_code","active"
      post "update_user_code"
    end
  end

  resources :questions do
    member do
      post "edit_question"
    end
  end
  resources :paper_blocks do
    member do
      post "choose_type"
    end
    collection do
      post "load_edit_problem"
      post "load_create_problem"
    end
  end
  resources :problems do
    collection do
      post "mavin_problem"
    end
    member do
      post "update_problem"
    end
  end

  resources :exam_users do
    collection do
      get "create_exam_user"
      post "add_item", "leadin"
    end
    member do
      get "new_exam_two"
      post "login"
      post "update_exam_user" 
    end
  end

  resources :exam_raters do
    collection do
      get "new_exam_three", "create_exam_rater"
    end
    member do
      get "accept_score","cancel_score","random_paper"
      post "update_exam_rater","login_rater"
    end
  end

  resources :examinations do
    collection do
      get "search_list", "new_exam_one"
      post "search"
    end
    member do
      get "export_user_unaffirm", "edit_base_info", "back_base_info",
        "published", "paper_delete", "search_papers", "choose_papers", "exam_result", "single_result_list", "close"
      post "create_step_one", "update_base_info", "search_result"
    end
  end
 
  resources :papers do
    collection do
      get "new_step_one", "search_list"
      post "create_step_one", "create_step_two", "search", "create_exam_one", "create_exam_two", "create_exam_three", "exam_list"
      post "problem_destroy", "edit_block"
    end
    member do
      get "new_step_two", "answer_paper", "create_all_paper"
      post "change_info", "hand_in"
    end
  end

  resources :uploads do
    collection do
      post "upload_images", "upload"
    end
  end


  #示例页面专用路由
  resources :pages do
    collection do
      get "create_step_one", "create_step_two", "edit", "create_exam_one", "create_exam_two", "create_exam_three",
        "exam_list", "show_exam", "edit_exam_base", "edit_exam_users", "edit_exam_raters", "setting",
        "result_list", "my_exam_list", "exam_results", "result_list", "show_result", "my_results", "answer_paper"
      get "rater_login", "paper_list", "rate_paper"
      get "exam_query_login", "my_results_simple", "user_exams"
    end
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

 



  root :to => "sessions#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
 
