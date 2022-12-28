class TestMailer < ApplicationMailer
  default from: "test@shortlaw.com"

  def test(to_email)
    mail to: to_email, subject: "Test email"
  end

end
