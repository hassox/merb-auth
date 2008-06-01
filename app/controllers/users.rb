class MerbfulAuthentication::Users < MerbfulAuthentication::Application
  provides :xml
  
  skip_before :login_required

  def new
    only_provides :html
    @ivar = MA[:user].new(params[:user] || {})
    set_ivar
    display @ivar
  end
  
  def create
    cookies.delete :auth_token
    
    @ivar = MA[:user].new(params[:user])
    set_ivar
    if @ivar.save
      redirect_back_or_default('/')
    else
      render :new
    end
  end
  
  def activate
    self.current_ma_user = MA[:user].find_with_conditions(:activation_code => params[:activation_code])
    if logged_in? && !current_ma_user.activated?
      Merb.logger.info "Activated #{current_ma_user}"
      current_ma_user.activate
    end
    redirect_back_or_default('/')
  end
  
  private
  def set_ivar
    instance_variable_set("@#{MA[:single_user_name]}", @ivar)
  end
  
end