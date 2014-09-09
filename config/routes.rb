Gielda::Application.routes.draw do
  get "companies/search"
  get "companies/calculator"
  get "pages/quiz", :as => :quiz
  get "pages/ranking", :as => :ranking
  get "pages/benchmark", :as => :benchmark
  get "pages/wallet"
  post "pages/set_profile"
  get "quotes/index"
  get "quotes/show/:id" => "quotes#show", :as => :quotes_show
end
