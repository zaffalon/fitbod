class ApiController < ActionController::API

  private def api_key_from_header
    bearer_pattern = /^Bearer /
    auth_header = request.env["HTTP_AUTHORIZATION"]

    return unless auth_header

    return auth_header.gsub(bearer_pattern, "") if auth_header.match(bearer_pattern)
  end

  private def authenticate
    @current_user_token = Session.find_by_token(api_key_from_header)

    if @current_user_token
      unless @current_user_token.decode_jwt
        @current_user_token.destroy
        render json: @current_user_token.errors, status: :unauthorized
        return false
      else
        @current_user_token.update(
          expiry_at: Time.current + Session::TTL,
          last_request_at: Time.current,
          last_request_ip: request.remote_ip,
        )

        @current_user = @current_user_token.user
      end
    else
      render json: { message: "Invalid access token", code: "invalid_token" }, status: :unauthorized
      return false
    end
  end

  private def current_user
    @current_user if defined?(@current_user)
  end
end
