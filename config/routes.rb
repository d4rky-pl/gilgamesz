Rails.application.routes.draw do
  root 'adventures#index'

  resources :adventures

  match '/help', to: 'subpages#help', via: :get, as: :help
end
