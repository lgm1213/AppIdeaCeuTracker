require "test_helper"

class LicenseMailerTest < ActionMailer::TestCase
  test "expiring_soon" do
    mail = LicenseMailer.expiring_soon
    assert_equal "Expiring soon", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
