class UserMailer < Merb::MailController
  
  def signup_notification
    @user = params[:user]
    render_mail
  end
  
  def activation_notification
    @user = params[:user]
    render_mail
  end
  
end