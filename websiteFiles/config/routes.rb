Rails.application.routes.draw do
  #resources :widgets

  root 'welcome#index'
  post '/superman', to: 'welcome#superman'
  
  resources :test do
    collection do
      get 'test'
    end
  end

end
