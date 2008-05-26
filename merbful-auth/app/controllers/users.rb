require File.join(File.dirname(__FILE__), '..', '..', "lib", "authenticated_system", "authenticated_dependencies")
class Users < Application
  provides :xml
  
  skip_before :login_required
  
  def new
    only_provides :html
    @user = User.new(params[:user] || {})
    display @user
  end
  
  def create
    cookies.delete :auth_token
    
    @user = User.new(params[:user])
    if @user.save
      redirect_back_or_default('/')
    else
      render :new
    end
  end
  
  def activate
    self.current_user = User.find_activated_authenticated_model(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
    end
    redirect_back_or_default('/')
  end
end