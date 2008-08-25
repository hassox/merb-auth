class Welcome < Application
  before :ensure_authenticated
  
  def index
    "We're In"
  end
  
end