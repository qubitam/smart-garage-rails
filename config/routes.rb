Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users

  resources :devices do
  	member do
	  	post 'on', to: 'devices#trigger_on_command'
	  	post 'off', to: 'devices#trigger_off_command'
	  	post 'capture', to: 'devices#trigger_capture_command'
	  end
	end

  get 'static_pages/home'
  get 'static_pages/documentation'
  get 'static_pages/goodbye'



end
