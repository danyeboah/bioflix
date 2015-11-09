class AdminsController < ApplicationController
  before_action :ensure_admin

  def ensure_admin
    if !current_user.admin
      flash["danger"] = "Admin rights required"
      redirect_to root_path
    end
  end

end