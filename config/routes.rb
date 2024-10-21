Rails.application.routes.draw do
  resources :items do
    collection do
      post :random_create
      get :create_random
      post :create_random
      post :get_item_name
      post :create_item
    end
    member do
      post :destroy
      post :get_item_name
      post :create_item
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
    end
  end

  resources :rarities do
    collection do
      post :get_rarities
    end
  end
  resources :weapons

  root 'main#index'
end
