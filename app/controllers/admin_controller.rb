class AdminController < ApplicationController
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  layout "admin"

  # 如果权限检查比较复杂，可以使用专门的 gem，比如 Pundit，Cancancan
  protected
    def require_editor!
      unless current_user.is_editor?
        flash[:alert] = "您的权限不足"
        redirect_to root_path
      end
    end

    def require_admin!
      unless current_user.is_admin?
        flash[:alert] = "您的权限不足"
        redirect_to root_path
      end
    end

end
