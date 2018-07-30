Rails.application.routes.draw do
  get '/contact', to: 'common#contact', as: 'contact_path'
  get '/about', to: 'common#about', as: 'about_path'
  devise_for :views
  devise_for :users
  root 'posts#index'
  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
