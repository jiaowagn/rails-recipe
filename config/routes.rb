Rails.application.routes.draw do

  devise_for :users

  resources :events do
    resources :registrations do
      member do
        get "/steps/1" => "registrations#step1", :as => :step1
        patch "/steps/1/update" => "registrations#step1_update", :as => :update_step1
        get "/steps/2" => "registrations#step2", :as => :step2
        patch "/steps/2/update" => "registrations#step2_update", :as => :update_step2
        get "/steps/3" => "registrations#step3", :as => :step3
        patch "/steps/3/update" => "registrations#step3_update", :as => :update_step3
      end
    end
  end

  namespace :admin do
    root "events#index"
    resources :events do
      resources :tickets, :controller => "event_tickets"
      resources :registrations, :controller => "event_registrations"
      member do
        post :reorder
      end
      collection do
        post :bulk_update
      end
    end
    resources :users do
      resource :profile, :controller => "user_profiles"
    end
  end

  get "/faq" => "pages#faq"

  # 这里的路由设计使用单数 resource:user，跟 resources :users 相比，单数的路由少了 index action，并且网址上不会有 ID，
  # 路由方法也皆为单数不需要参数，例如 user_path、edit_user_path
  resource :user

  root "events#index"

end
