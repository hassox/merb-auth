class MerbfulAuthentication::Sessions < MerbfulAuthentication::Application
  
  skip_before :login_required
  

  
end