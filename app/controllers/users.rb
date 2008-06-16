class MerbAuth::Users < MerbAuth::Application
  
  skip_before :login_required
  
end