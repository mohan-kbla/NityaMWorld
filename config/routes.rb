Rails.application.routes.draw do
  # Reveal health status on /up
  get "up" => "rails/health#show", as: :rails_health_check

  # User Authentication via Devise
  devise_for :users

  # Admin Panel Namespace
  namespace :admin do
    root to: "dashboard#index"

    resources :products
    resources :categories
    resources :brands
    resources :orders, only: [:index, :show, :update] do
      member do
        get :invoice
        get :packing_slip
        post :cancel
        post :refund
      end
    end
    resources :customers, only: [:index, :show]
    resources :coupons
    resources :banners
    resources :testimonials
    resources :blogs
    resources :pages
    resources :reviews, only: [:index, :destroy] do
      member do
        patch :approve
        patch :reject
      end
    end
    resources :users
  end

  # Customer Storefront Routes
  root to: "home#index"

  resources :shop, only: [:index, :show], param: :slug
  resource :cart, only: [:show, :update, :destroy] do
    post :add_item
    post :apply_coupon
    post :remove_coupon
  end

  resources :checkout, only: [:new, :create] do
    collection do
      get :payment
      post :payment_callback
      get :confirmation
    end
  end

  resources :orders, only: [:show]
  resources :reviews, only: [:create]
  resources :wishlists, only: [:index, :create, :destroy]
  
  # Static informational pages
  get "p/:slug", to: "pages#show", as: :static_page
  resources :blogs, only: [:index, :show], param: :slug
end
