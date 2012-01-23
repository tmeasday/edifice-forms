Rails31::Application.routes.draw do
  resources :users do
    collection do
      get :new_html, :new_json
    end
  end
end
