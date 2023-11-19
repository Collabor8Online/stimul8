Rails.application.routes.draw do
  mount Stimul8::Engine => "/stimul8"

  resource :simple_action
end
