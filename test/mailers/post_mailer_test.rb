require 'test_helper'

class PostMailerTest < ActionMailer::TestCase
  test "new_post_notification" do
    mail = PostMailer.new_post_notification(Post.new(title: 'Test title', body: 'Test body'))
    assert_equal "New post notification", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    #assert_match "Hi", mail.body.encoded
  end

end
