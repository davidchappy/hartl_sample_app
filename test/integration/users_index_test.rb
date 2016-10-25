require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:fred)
    @non_admin = users(:ethel)
  end
  
  test "index including pagination" do
    log_in_as(@admin)  
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
  # test "shouldn't index unactivated users" do
  #   get signup_path
  #   assert_difference 'User.count', 1 do
  #     post signup_path, params: { user: { name:                   "Example User",
  #                                         email:                  "user@example.com",
  #                                         password:               "password",
  #                                         password_confirmation:  "password" } }
  #   end
  #   user = assigns[:user]
  #   assert_not is_logged_in?
  #   log_in_as(@admin)
  #   get users_path
  #   assert_not "a", "Example User"
  # end
  
end
