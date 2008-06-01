class MerbfulAuthentication::Sessions < MerbfulAuthentication::Application
  
  skip_before :login_required
  
  def new
    render
  end

  def create
    self.current_ma_user = MA[:user].authenticate(params[:email], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_ma_user.remember_me
        expires = Time.parse(self.current_ma_user.remember_token_expires_at.to_s)
        cookies[:auth_token] = { :value => self.current_ma_user.remember_token , :expires => expires }
      end
      redirect_back_or_default('/')
    else
      render :new
    end
  end

  def destroy
    self.current_ma_user.forget_me if logged_in?
    cookies.delete :auth_token
    session.delete
    redirect_back_or_default('/')
  end
  
end