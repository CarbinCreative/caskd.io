Rails.application.routes.draw do

  root controller: :application, action: :index

  namespace :api do

    resources :distilleries, constraints: { id: /[a-z0-9.-]+/ }

  end

end
