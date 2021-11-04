class SessionsController < ApplicationController
  before_action :authenticate, only: :destroy

  def create
    if params[:email]
      user = User.find_by(email: params[:email])
      unless user.present?
        return render json: { message: "invalid_login", code: "invalid_login" }, status: :unprocessable_entity
      end

      if user&.valid_password?(params[:password])
        session = Session.create!(
          user_id: user.id,
          expiry_at: Time.current + Session::TTL,
          user_agent: request.user_agent,
          create_ip: request.remote_ip,
        )
    

        render json: { token: session.token }, status: :created
      else
        render json: { message: "invalid_login", code: "invalid_login" }, status: :unprocessable_entity
      end
    else
      render json: { message: "invalid_login", code: "invalid_login" }, status: :unprocessable_entity
    end
  end
  
end
