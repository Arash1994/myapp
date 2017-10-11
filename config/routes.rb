Rails.application.routes.draw do
  namespace :admin do
    resources :categories
  end
  namespace :admin do
   resources :members, controllers: { members: 'admin/members' }
  end

  root 'posts#index'
  resources :posts
  # devise_for :users
  devise_for :users, controllers: { registrations: 'users/registrations'}
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
