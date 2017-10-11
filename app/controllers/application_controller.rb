class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: { success: false, message: e, data: {} }, status: 404
  end

  rescue_from I18n::InvalidLocale, :with => :locale_not_valid

  rescue_from ActiveModel::StrictValidationFailed do |e|
    render json: { success: false, message: e, data: {} }, status: 404
  end


  rescue_from CustomErrors::MissingParams do |e| redirect_to new_post_path(flash[:error] = "#{e.names} missing")
    end

  private
  def check_required_params(params, required_params)
    missing_params = []
    required_params.each { |p|
    	 
    	missing_params << p if params[p].blank?
    	}
    raise CustomErrors::MissingParams.new(missing_params) if missing_params.any?
  end
end
