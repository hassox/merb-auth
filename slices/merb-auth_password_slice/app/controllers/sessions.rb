class MerbAuthPasswordSlice::Sessions < MerbAuthPasswordSlice::Application
  before :ensure_authenticated

  # redirect from an after filter for max flexibility
  # We can then put it into a slice and ppl can easily 
  # customize the action
  after :redirect_after_login,  :only => :update, :if => lambda{ !(300..499).include?(status)}
  after :redirect_after_logout, :only => :destroy
  
  def update
    "Add an after filter to do stuff after login"
  end

  def destroy
    session.abandon!
    "Add an after filter to do stuff after logout"
  end
  
  
  private 
  def redirect_after_login
    Merb.logger.info "IN THE AFTER FILTER DOODLE"
    redirect "/", :message => "Authenticated Successfully"
  end
  
  def redirect_after_logout
    raise Unauthenticated, "Thank you, come again - Apu Nahasapeemapetilon"
  end  
end