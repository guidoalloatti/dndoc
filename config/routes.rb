Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations"
  }

  scope "(:locale)", locale: /en|es/ do
    namespace :admin do
      root "dashboard#index"
      resources :users, only: [:index, :show] do
        member do
          patch :toggle_admin
        end
      end
      resources :character_classes
    end

    resource :profile, only: [:show, :edit, :update]

    resources :items do
      collection do
        post :random_create
        get :create_random
        post :create_random
        post :get_item_name
        post :create_item
        post :get_item
        post :update_item
        post :recommend_effects
        get :wizard
        post :wizard
      end
      member do
        post :destroy
        post :get_item_name
        post :create_item
        post :get_item
        post :update_item
      end
      resources :effects, only: [:new, :create, :edit, :update]
    end
    resources :categories

    resources :effects do
      collection do
        post :get_effects_by_category
      end
      member do
        post :get_effects_by_category
        get :detail_panel
      end
    end

    resources :rarities do
      collection do
        post :get_rarities
      end
    end
    resources :weapons

    resources :party_rewards, only: [:new] do
      collection do
        post :generate
        post :regenerate_item
        post :save_all
      end
    end

    root 'main#index'
  end

  # Silently ignore socket.io requests from browser extensions/dev tools
  match "/socket.io", to: proc { [404, {}, [""]] }, via: :all
end
