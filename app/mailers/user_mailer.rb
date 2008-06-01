class MerbfulAuthentication::UserMailer < Merb::MailController
  
  def signup
    @ivar = params[MA[:single_resource]]
    instance_variable_set("@#{MA[:single_resource]}", @ivar )
    render_mail :text => :signup
  end
  
  def activation
    @ivar = params[MA[:single_resource]]
    instance_variable_set("@#{MA[:single_resource]}", @ivar )
    render_mail :text => :activation
  end
  
  def forgot_password
    @ivar = params[MA[:single_resource]]
    instance_variable_set("@#{MA[:single_resource]}", @ivar )
    render_mail :text => :forgot_password
  end
  
  private  
  def _template_location(action, type = nil, controller = controller_name)
    "/merbful_authentication/user_mailer/#{action}.#{type}"
  end
  
  def method_missing(*args)
    if @base_controller
      @base_controller.send(:method_missing, *args) 
    else
      super(*args)
    end
  end
    
end