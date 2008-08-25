class MauthPasswordSlice::Sessions < MauthPasswordSlice::Application
  skip_before :ensure_authenticated

  # redirect from an after filter for max flexibility
  # We can then put it into a slice and ppl can easily 
  # customize the action
  after :redirect_after_login, :only => :update

  after :redirect_after_logout, :only => :destroy
  
  def update
    session.abandon!
    session.authenticate(self)
    "Add an after filter to do stuff after login"
  end

  def destroy
    session.abandon!
    "Add an after filter to do stuff after logout"
  end
  
  
  private 
  def redirect_after_login
    redirect "/", :message => "Authenticated Successfully"
  end
  
  def redirect_after_logout
    raise Unauthenticated, "Thank you, come again - Apu Nahasapeemapetilon"
  end  
end