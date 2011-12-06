Printatcu::Application.routes.draw do
  resources :prints, :only => :create
  root :to => "prints#index"
  mount Resque::Server.new, :at => "/resque"
end
