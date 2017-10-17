class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
   @user =  User.create(sign_up_params)
   if @user.save
     # Save the user_id to the session object
      session[:user_id] = @user.id

      # Create user on Authy, will return an id on the object

      authy = Authy::API.register_user(
        email: @user.email,
        cellphone: @user.phone_number,
        country_code: @user.country_code
      )
      @user.update(authy_id: authy.id)

      # Send an SMS to your user
      Authy::API.request_sms(id: @user.authy_id)

      redirect_to show_verify_path
    else
      render :new
    #   flash[:success] ="Success!"
    #   redirect_to root_path(@user)
    # else
    #   flash[:error] =@user.errors.full_messages
    #   redirect_to new_user_registration_path(@user)
    end
  end


  def show_verify
    return redirect_to new_user_path unless session[:user_id]
  end

  def verify
    @user = User.find_by_id(session[:user_id])

    # Use Authy to send the verification token
    token = Authy::API.verify(id: @user.authy_id, token: params[:token])

    if token.ok?
      # Mark the user as verified for get /user/:id
      @user.update(verified: true)

      # Send an SMS to the user 'success'
      # send_message("You did it! Signup complete :)")

      # Show the user profile
      flash[:success] ="Success!"
     redirect_to root_path(@user)
    else
      flash.now[:danger] = "Incorrect code, please try again"
      render :show_verify
    end
  end

  def resend
    @user = User.find_by_id(session[:user_id])
    Authy::API.request_sms(id: @user.authy_id)
    flash[:notice] = 'Verification code re-sent'
    redirect_to show_verify_path
  end

  def destroy
    debugger
   resource.destroy
   Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
   set_flash_message! :notice, :destroyed
   yield resource if block_given?
   respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
 end


  protected

  def send_message(message)
    @user = User.find_by_id(session[:user_id])
    twilio_number = "901-472-7376"
    account_sid =  Rails.application.secrets.account_sid
    @client = Twilio::REST::Client.new account_sid, Rails.application.secrets.auth_token
    message = @client.api.accounts(account_sid).messages.create(
      :from => twilio_number,
      :to => @user.country_code+@user.phone_number,
      :body => message
    )
  end

  def sign_up_params
   params.require(:user).permit(:email, :password, :password_confirmation, :role, :country_code, :phone_number)
  end

  def user_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role])
    end
end
