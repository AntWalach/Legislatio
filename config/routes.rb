Rails.application.routes.draw do
  
  resources :notifications, only: [] do
    member do
      patch :mark_as_read
    end
  end

  resources :bills do
    resource :bill_committee do
      post :sign
    end
    post 'sign', to: 'signatures#bill_create'
    post :initialize_committee_formation
  end

  resources :petitions do
    post 'sign', to: 'signatures#petition_create'
    member do
      post :start_collecting_signatures
      post :submit
    end
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
 
  get "/landing", to: 'main#landing', as: 'landing'
  
  
  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy', as: 'logout'  

    authenticated :user do
      root 'users#dashboard', as: :authenticated_root
    end

    unauthenticated do
      root 'main#landing', as: :unauthenticated_root
    end
  end

  resources :users do
  end


  namespace :officials do
    resources :bills, only: [:index, :show] do
      member do
        post :approve_committee
        post :approve_for_signatures
        post :start_collecting_signatures
        post :verify_signatures
        post :marshal_review
        post :committee_review
      end
    end

    resources :petitions, only: [:index, :show] do
      member do
        post :approve
        post :reject
        post :verify_signatures
        post :respond
      end
    end
  end

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update, :destroy]
  end
end
