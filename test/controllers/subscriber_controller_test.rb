require 'test_helper'

class SubscriberControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get subscriber_new_url
    assert_response :success
  end

  test "should get save" do
    get subscriber_save_url
    assert_response :success
  end

end
