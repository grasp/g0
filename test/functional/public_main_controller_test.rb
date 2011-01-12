require 'test_helper'

class PublicMainControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
