Rails.application.routes.draw do
  devise_for :users
  devise_for :models
  get 'home/index'
  
  resources :executions
  
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  
  
  get "more_info", :to => "home#more_info"
  get "faq", :to => "home#faq"
  get "credits", :to => "home#credits"
  
  resources :executions do
      member { post 'notify' }
      collection do
          post 'notify'
          get 'executions_list'
      end
  end

  
  resources :uploaded_files, :path => "files", :controller => :files
  resources :files
  
end
