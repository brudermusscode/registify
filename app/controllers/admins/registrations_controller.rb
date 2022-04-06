# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :admin_signed_in!
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  skip_before_action :require_no_authentication, only: %i[new create cancel]
  before_action :require_last_admin, only: :destroy

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    if resource.save
      flash[:notice] = I18n.t('administration.admins.flash.success.created')
      expire_data_after_sign_in!
      respond_with resource, location: admins_path
    else
      respond_with resource, location: new_admin_registration_path
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def admin_signed_in!
    redirect_back fallback_location: root_path unless admin_signed_in?
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[firstname email lastname username city postcode born_at street password
                                               password_confirmation])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[firstname email lastname username city postcode born_at street password
                                               password_confirmation current_password])
  end

  # def sign_up(_resource_name, _resource)
  # end

  # The path used after sign up.
  def after_sign_up_path_for(_resource)
    root_path
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #  super(resource)
  # end
end
