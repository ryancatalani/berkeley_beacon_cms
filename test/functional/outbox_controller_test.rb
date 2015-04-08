require 'test_helper'

class OutboxControllerTest < ActionController::TestCase
  test "should get weekly_newsletter" do
    get :weekly_newsletter
    assert_response :success
  end

end
