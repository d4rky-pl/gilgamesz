Rails.application.routes.draw do
  root 'adventures#index'

  resources :adventures do
    match '/like', to: 'adventures#like', via: :post, as: :like
  end

  match '/help', to: 'subpages#help', via: :get, as: :help
end
