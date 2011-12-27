Printatcu::Application.routes.tap do |routes|
  routes.default_scope = {format: false}

  routes.draw do
    resources :prints, :only => :create
    root :to => "prints#index"
    mount Resque::Server.new, :at => "/resque"
  end
end
