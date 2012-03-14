Printatcu::Application.routes.tap do |routes|
  routes.default_scope = {format: false}

  routes.draw do
    get "/" => "prints#index", :as => :print
    post "/prints" => "prints#create", :as => :create_print
    get "/preferences" => "prints#preferences", :as => :print_preferences
    mount Resque::Server.new, :at => "/resque"
  end
end
