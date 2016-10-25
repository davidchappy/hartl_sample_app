require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  setup do
    @user = users(:fred)
  end
  
  test "site navigation for new user" do
    get root_path
    assert_not is_logged_in?
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", 'http://news.railstutorial.org/'
    get about_path  
    assert_select "title", full_title("About")
    get contact_path  
    assert_select "title", full_title("Contact")
    get help_path  
    assert_select "title", full_title("Help")
    get signup_path
    assert_select "title", full_title("Sign up")
    assert_select 'form[action="/signup"]'
    assert_difference 'User.count' do 
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    user = assigns(:user)
    assert_not user.activated?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert is_logged_in?
    assert_template 'users/show'
    assert_not flash.empty?
  end
  
  test "site navigation for logged in user" do
    get root_path
    assert_not is_logged_in?
    get login_path
    log_in_as(@user, remember_me: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    get users_path
    assert_select "h1", "All Users"
    assert_select 'img[class="gravatar"]'
    assert_select 'a[href=?]', user_path(@user)
    assert_select 'a', @user.name
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  
end
