class MerbAuth::Sessions < MerbAuth::Application
  
  skip_before :login_required
  

  
end