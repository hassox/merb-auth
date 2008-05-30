class MerbfulAuthentication::UserMailer < Merb::MailController
  
  def signup_notification
    @ivar = params[MA[:single_resource]]
    instance_variable_set("@#{MA[:single_resource]}", @ivar )
    render_mail :text => :signup_notification
  end
  
  def activation_notification
    @ivar = params[MA[:single_resource]]
    instance_variable_set("@#{MA[:single_resource]}", @ivar )
    render_mail :text => :activation_notification
  end
  
  def forgot_password
    @ivar = params[MA[:single_resource]]
    instance_variable_set("@#{MA[:single_resource]}", @ivar )
    render_mail :text => :forgot_password
  end
  
  private
  def method_missing(*args)
    if @base_controller
      @base_controller.send(:method_missing, *args) 
    else
      super(*args)
    end
  end
    
end