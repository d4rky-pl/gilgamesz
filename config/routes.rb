Rails.application.routes.draw do

  root 'adventures#index'

  resources :adventures do
    match '/like', to: 'adventures#like', via: :post, as: :like
  end

  match '/about', to: 'subpages#about', via: :get, as: :about

end
