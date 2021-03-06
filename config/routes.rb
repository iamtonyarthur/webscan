Rails.application.routes.draw do
  devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout"}

  get 'welcome/index'

  root 'welcome#index'

  get 'check_websites', to: 'domains#check_websites'

  resources :domains do
    collection {post :import}
  end
end
