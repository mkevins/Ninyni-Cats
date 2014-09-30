Rails.application.routes.draw do

  resources :cats do
    resources :requests, only: [:new]
  end

  resources :requests, only: [:edit, :show, :index, :create]

end
