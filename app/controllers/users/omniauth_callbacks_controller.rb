class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_service
  before_action :set_user

  attr_reader :service, :user

  def facebook
    handle_auth "facebook"
  end

  def google_oauth2
    handle_auth "google"
  end

    private

  def handle_auth(kind)
    if service.present?
      service.update(service_attrs)
    else
      user.services.create(service_attrs)
    end

    if user_signed_in?
      flash[:notice] = "Your #{kind} account was connected."
      redirect_to edit_user_registration_path
    else
      sign_in_and_redirect user, event: :authentication
      set_flash_message :notice, :success, kind: kind
    end
  end

  def auth
    request.env['omniauth.auth']
  end

  def set_service
    @service = Service.where(provider: auth.provider, uid: auth.uid).first
  end

  def set_user
    if user_signed_in?
      @user = current_user
    elsif service.present?
      @user = service.user
    elsif User.where(email: auth.info.email).any?
            flash[:alert] = "An account with this email already exists. Please sign in with that account before connecting to your #{auth.provider} account"
            redirect_to new_user_session_path
    else
      @user = create_user
    end
  end

    def service_attrs
    expires_at = auth.credentials.expires_at.present? ? Time.at(auth.credentials.expires_at) : nil
    {
        provider: auth.provider,
        uid: auth.uid,
        expires_at: expires_at,
        access_token: auth.credentials.token,
        access_token_secret: auth.credentials.secret,
    }
   end
   def create_user
    user = User.create(
        email: auth.info.email,
        #name: auth.info.name
        password: Devise.friendly_token[0, 20]
    )
   end
end
  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
