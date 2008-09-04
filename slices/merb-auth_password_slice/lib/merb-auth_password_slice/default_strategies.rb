class MpsPasswordLoginFromForm < ::Authentication::Strategy
  def run!
    if params[:login] && params[:password]
      MaPS[:user_class].authenticate(params[:login], params[:password])
    end
  end
end

class MpsPasswordLoginBasicAuth < ::Authentication::Strategy
  def run!
    if controller.basic_authentication.provided?
      controller.basic_authentication.authenticate do |login, password|
        user = MaPS[:user_class].authenticate(login, password) 
        unless user
          controller.basic_authentication.request!
          throw(:halt, "Login Required")
        end
        user
      end
    end
  end
end