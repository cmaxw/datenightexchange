require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get canvas" do
    get :canvas
    assert_response :success
  end

end
