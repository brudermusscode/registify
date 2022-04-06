class ApplicationController < ActionController::Base
  # before_action :set_locale
  # set the creator of version changes for any paper trail module
  before_action :set_paper_trail_whodunnit

  # for paper trail
  def set_paper_trail_whodunnit
    PaperTrail.request.whodunnit = current_session_scope
  end

  def store_location!
    session[:redirect_to] = if request.post? || request.put?
                              request.env['HTTP_REFERER']
                            else
                              request.fullpath
                            end
  end

  def require_last_admin
    if Admin.all.count < 2
      flash_alert_with t('administration.flash.admin.require_last')
      redirect_back fallback_location: %i[manage admins]
    end
  end

  # def set_locale
  #  I18n.locale = I18n.default_locale || params[:locale]
  # end

  def all_users
    @users = User.all
  end

  def flash_notice_with(message)
    flash[:notice] = message
  end

  def flash_alert_with(message)
    flash[:alert] = message
  end

  def admin_signed_in!
    redirect_back fallback_location: root_path unless admin_signed_in?
  end

  def user_signed_in!
    redirect_to root_path, notice: t('flash.please_login') unless user_signed_in?
  end

  def current_session_scope
    helpers.current_session_scope
  end

  def redirect_no_permissions
    redirect_back fallback_location: root_path, alert: t('flash.no_permissions')
  end

  def all_count(model)
    model.all.count
  end

  # devise stuff
  def after_sign_in_path_for(resource)
    [resource.profile]
  end
end
