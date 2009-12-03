require 'test_helper'

class UserSessionsControllerTest < ActionController::TestCase
  test "redirect to home after login" do
    user = Factory(:user)

    post :create, :user_session => { :username => user.username, :password => user.password }
    
    assert assigns(:user_session).errors.blank?
    assert_redirected_to root_url 
  end
  
  test "render new if the user passed wrong credentials" do
    user = Factory(:user)

    post :create, :user_session => { :username => user.username, :password => "wrong password" }
    
    assert !assigns(:user_session).errors.blank?
    assert_template :new
  end
end
