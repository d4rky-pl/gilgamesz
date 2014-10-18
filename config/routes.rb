Rails.application.routes.draw do
  root 'adventures#index'

  resources :adventures
end
