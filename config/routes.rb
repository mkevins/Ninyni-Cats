Rails.application.routes.draw do

  resources :cats do
    resources :requests, only: [:new]
  end

  resources :requests, only: [:edit, :show, :index, :create] do
    patch "approve"
    patch "deny"
  end

  resource :user, only: [:new, :create, :edit, :update]

  resource :session, only: [:new, :create] do
    delete "destroy", as: "destroy"
  end

end
