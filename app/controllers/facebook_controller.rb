require "base64"

class FacebookController < ApplicationController
  def canvas
    @signed_request = Base64.decode64(params[:signed_request])
    logger.info @signed_request.inspect
  end
end
