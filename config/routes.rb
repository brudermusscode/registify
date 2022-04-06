Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  devise_for  :admins,
              controllers: {
                sessions: 'admins/sessions',
                registrations: 'admins/registrations'
              }

  namespace :manage do
    root 'main#index'

    resources :users do
      member do
        patch  'approve'
        patch  'lock'
        patch  'free'
      end

      scope module: 'users' do
        # users lists overview
        resources :lists
        get 'lists', on: :collection, to: 'lists#overview'
      end
    end

    resources :admins do
      scope module: 'admins' do
        # admins lists overview
        resources :lists
        get 'lists', on: :collection, to: 'lists#overview'
      end
    end
  end

  resources :profiles do
    resources :lists, module: 'profiles' do
      scope module: 'lists' do
        resources :items, path: 'items', as: 'list_items'
        resources :versions, path: 'versions', as: 'list_versions'
        resources :permissions, path: 'subscribers', as: 'list_permissions'
        resources :invitations, path: 'invites', as: 'list_invitations' do
          post 'accept', on: :member
        end
        resources :requests, path: 'requests', as: 'list_requests' do
          post 'accept', on: :member
        end
      end
    end
  end

  # invitations 'show' action page for accepting invitation to lists
  get 'inv/:token', to: 'profiles/lists/invitations#show', as: 'show_list_invitation'

  # root_path
  root 'main#index'
end
