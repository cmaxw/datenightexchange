require 'base64'
require 'openssl'

class FacebookController < ApplicationController
  def canvas
    if fb_data = facebook_signed_request?(params[:signed_request], "2cbe9ab9f816c6994d239ee12f30f336")
      redirect_to :text => "<script> top.location.href='http://www.facebook.com/dialog/oauth?client_id=9dc82e8d3754dbc2f2e851f1a8e74b82&redirect_uri=#{CGI.escape("http://datenightexchange.com/facebook/canvas/")}' </script>", :layout => false
    end
  end

  def facebook_signed_request? (signed_request, secret)

    def base64_url_decode str
      encoded_str = str.gsub('-','+').gsub('_','/')
      encoded_str += '=' while !(encoded_str.size % 4).zero?
      Base64.decode64(encoded_str)
    end

    def str_to_hex s
      (0..(s.size-1)).to_a.map do |i|
        number = s[i].to_s(16)
        (s[i] < 16) ? ('0' + number) : number
      end.join
    end

    #decode data
    encoded_sig, payload = signed_request.split('.')
    sig = str_to_hex(base64_url_decode(encoded_sig))
    data = ActiveSupport::JSON.decode base64_url_decode(payload)

    if data['algorithm'].to_s.upcase != 'HMAC-SHA256'
  #    Rails.logger.error 'Unknown algorithm. Expected HMAC-SHA256'
      return false
    end

    #check sig
    expected_sig = OpenSSL::HMAC.hexdigest('sha256', secret, payload)
    if expected_sig != sig
  #    Rails.logger.error 'Bad Signed JSON signature!'
      return false
    end

    data
  end
  
end
