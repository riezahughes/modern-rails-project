require 'resque/server'
Rails.application.routes.draw do

  resources :account_increases
  get 'court_date_diary/show'

  post 'templateable_document_meeting/new_precognition_templateable_document'
  post 'templateable_document_meeting/new_meeting_templateable_document'
  post 'templateable_document/new_form_templateable_document'
  post 'templateable_document/new_templateable_document'

  put 'legacy_cabinet_file/fetch_file'

  resources :documents do
    collection do
      get :autocomplete_client_file_file_number
      get :autocomplete_client_name
    end

    member do
      get :download
    end
  end

  resources :jurisdictions
  concern :document_templateable do
    member do
      get :download
    end
  end

  resources :precognitions, concerns: :document_templateable do

  end

  resources :debit_entries, concerns: :document_templateable do
    collection do
      get :autocomplete_client_file_file_number
    end
  end

  resources :document_templates do
    member do
      get :download
    end

    collection do
      get :new_mutiple_file_upload
      post :multiple_file_upload
      get :autocomplete_document_templates_name
      get :by_category
    end
  end

  resources :file_forms, concerns: :document_templateable do
    collection do
      get :autocomplete_client_file_file_number
    end
  end

  resources :payments do
    collection do
      post :import
      get :breakdown
    end
  end

  resources :user_types
  resources :item_charge_rates
  resources :item_charge_rates
  resources :account_charge_rates
  resources :account_charge_items, except: [:new, :create]

  resources :attendance_appearings do
    collection do
      get :autocomplete_court_date_identifier
    end
  end

  resources :attendance_waitings do
    collection do
      get :autocomplete_court_date_identifier
    end
  end

  resources :claims do
    collection do
      get :autocomplete_account_identifier
      get :work_in_progress_report
    end
  end

  get 'witnesses/multi_select_row'

  concern :witnessable do
    collection do
      get :autocomplete_client_file_file_number
    end
  end

  resources :civilians, concerns: :witnessable
  resources :police_officers, concerns: :witnessable

  resources :court_dates do
    collection do
      get :autocomplete_client_file_file_number
      get :autocomplete_journey_identifier
    end
  end

  resources :court_date_types

  concern :notifiable do
    member do
      post :register_for_notification
      post :unregister_for_notification
    end
  end

  resources :notifications
  resources :phone_calls, concerns: :notifiable do
    member do
      get :sheet
    end
    collection do
      get :autocomplete_client_file_file_number
      get :autocomplete_phone_call_attendance_with
    end
  end

  resources :disclosures do
    member do
      get :document_link
    end
  end
  resources :travel_methods
  resources :travels do
    collection do
      get :autocomplete_journey_identifier
    end
  end

  resources :journeys do
    collection do
      post :add_travel_to_form
      post :add_meeting_to_form
      post :add_court_date_to_form
    end
  end

  resources :meeting_types
  resources :meetings, concerns: [:notifiable, :document_templateable] do
    collection do
      get :autocomplete_client_file_file_number
      get :autocomplete_meeting_attendance_with
      get :autocomplete_journey_identifier
    end
  end

  resources :letters, concerns: [:notifiable, :document_templateable] do
    collection do
      get :autocomplete_client_file_file_number
    end
  end

  resources :ledgers do
    collection do
      get :get_balance
      get :autocomplete_client_name
    end
  end

  resources :client_file_types

  resources :account_types do
    resources :item_charge_rates, controller: :account_type_item_charge_rates, only: [:index, :update]
  end

  resources :accounts do
    collection do
      get :autocomplete_client_file_file_number
    end

    member do
      post :charge
      get :expenses_report
    end

    resources :account_charge_items, controller: :account_account_charge_items do
      collection do
        post :charge
        delete :destroy_all
      end
    end
  end

  resources :client_file_informations

  resources :procurator_fiscals

  resources :police_authorities

  resources :court_official_types

  resources :court_officials

  resources :court_types

  resources :courts

  resources :client_files do
    collection do
      get :search
      get :get_next_file_number
      get :autocomplete_client_name
    end

    member do
      get :folder_contents
      get :folder_link
      post :create_folder

      patch :upload_main_file_document
      patch :upload_disclosure
      patch :upload_to_document_store
      patch :reopen

      get :meetings
      get :court_dates

      resources :witnesses do
        put :change_witness_cited, controller: :client_files
        post :create_forms, on: :collection
      end
    end
  end

  resources :location_types

  resources :locations do
    collection do
      get :client_report
    end
  end

  resources :clients do
    collection do
      get :search
      get :balance_report

      resources :client_files do
        collection do
          resources :phone_calls, controller: :client_client_file_phone_calls, only: [:create]
        end
      end
    end

    member do
      get :client_file_report
      get :folder_contents
      get :folder_link
      post :create_folder
      get :client_files
    end
  end

  resources :groups

  devise_for :users, controllers: {sessions: 'users/sessions',
                                   registrations: 'users/registrations'}
  get 'static_pages/home'
  get 'help', to: 'static_pages#help'
  get 'help/document_templates', to: 'static_pages#document_templates_help'
  resources :users

  mount PdfjsViewer::Rails::Engine => "/pdfjs", as: 'pdfjs'
  mount Resque::Server.new, at: "/resque"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
