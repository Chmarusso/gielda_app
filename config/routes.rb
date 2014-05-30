Gielda::Application.routes.draw do
  get "quotes/index"
  get "quotes/show/:id" => "quotes#show", :as => :quotes_show
end
