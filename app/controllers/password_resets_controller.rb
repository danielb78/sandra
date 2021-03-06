class PasswordResetsController < ApplicationController
  skip_before_action :validate_auth_scheme, only: :show
  skip_before_action :authenticate_client, only: :show
  skip_before_action :authenticate_user
  before_action :skip_authorization

  def show
    new_reset = PasswordReset.new({ reset_password_token: params[:reset_token] })
    redirect_to new_reset.redirect_url
  end

  def create
    if reset.create
      UserMailer.reset_password(reset.user).deliver_now
      render status: :no_content, location: reset.user
    else
      unprocessable_entity!(reset)
    end
  end

  def update
    reset.reset_password_token = params[:reset_token]

    if reset.update
      render status: :no_content, location: reset.user
    else
      unprocessable_entity!(reset)
    end
  end

  private

  def reset
    @reset ||= PasswordReset.new(reset_params)
  end

  def reset_params
    params.require(:data).permit(:email, :reset_password_redirect_url, :password)
  end
end