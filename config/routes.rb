Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  resources :activities, :tournaments, :teams, :fixtures

  get 'tournaments/:id/add_teams', to: 'tournaments#add_teams', as: 'add_teams'
  patch 'tournaments/:id/generate_schedule', to: 'tournaments#generate_schedule', as: 'generate_schedule'
  get 'tournaments/:id/update_schedule', to: 'tournaments#update_schedule', as: 'update_schedule'
  put 'update_details', to: 'fixtures#update_details', as: 'update_details'
  
  get 'fixtures/:id/enter_result', to: 'fixtures#enter_result', as: 'enter_result'
  patch 'fixtures/:id/record_result', to: 'fixtures#record_result', as: 'record_result'

  put 'add_team_json', to: 'teams#add_team_json', as: 'add_team_json'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
