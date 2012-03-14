Printatcu::Application.routes.tap do |routes|
  routes.default_scope = {format: false}

  routes.draw do
    get "/" => "prints#index", :as => :print
    post "/prints" => "prints#create", :as => :create_print
    mount Resque::Server.new, :at => "/resque"
  end
end
