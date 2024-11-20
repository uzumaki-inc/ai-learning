class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    # 仮
    @current_user ||= User.find_or_create_by!(demo_user_identifier:)
  end

  def demo_user_identifier
    session[:demo_user_identifier] ||= SecureRandom.uuid
  end
end
