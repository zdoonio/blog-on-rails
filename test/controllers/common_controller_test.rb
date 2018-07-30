require 'test_helper'

class CommonControllerTest < ActionDispatch::IntegrationTest
  test "should get contact" do
    get common_contact_url
    assert_response :success
  end

  test "should get about" do
    get common_about_url
    assert_response :success
  end

end
