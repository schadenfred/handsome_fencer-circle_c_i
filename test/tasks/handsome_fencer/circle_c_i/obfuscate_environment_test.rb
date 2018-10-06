# test/lib/user_notify_test.rb
require 'test_helper'

class HandsomeFencer::CircleCI::ObfuscateEnvironmentTaskTest < ActiveSupport::TestCase
  setup do
    @confirmed_user = User.create(email: "john@appleseed.com", confirmed_at: Time.now)
    @unconfirmed_user = User.create(email: "jane@doe.com", confirmed_at: nil)
    MyApplication::Application.load_tasks
    Rake::Task['users:remove_unconfirmed'].invoke
  end

  test "unconfirmed user is deleted" do
    assert_nil User.find_by(email: "jane@doe.com")
  end

  test "confimed user is not deleted" do
    assert_equal @confimed_user, User.find_by(email: "john@appleseed.com")
  end
end
