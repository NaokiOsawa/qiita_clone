Rails.application.routes.draw do
  root "homes#index"

  # reload 対策
  get "sign_up", to: "homes#index"
  get "sign_in", to: "homes#index"
  get "articles/new", to: "homes#index"
  get "articles/:id/edit", to: "homes#index"
  get "articles/:id", to: "homes#index"

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for "User", at: "auth", controllers: {
        registrations: "api/v1/auth/registrations",
      }
      namespace :articles do
        resources :drafts, only: [:index]
      end
      namespace :current do
        resources :articles, only: [:index]
      end
      namespace :articles do
        resources :draft, only: [:index, :show]
      end
      resources :articles
    end
  end
end
