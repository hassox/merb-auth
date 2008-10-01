# Impelments redirect_back_or.  i.e. remembers where you've come from on a failed login
# and stores this inforamtion in the session.  When you're finally logged in you can use
# the redirect_back_or helper to redirect them either back where they came from, or a pre-defined url.
# 
# Here's some examples:
#
#  1. User visits login form and is logged in
#     - redirect to the provided (default) url
#
#  2. User vists a page (/page) and gets kicked to login (raised Unauthenticated)
#     - On successful login, the user may be redirect_back_or("/home") and they will 
#       return to the /page url.  The /home  url is ignored
#
#

#
module Merb::AuthenticatedHelper
  
  # Add a helper to do the redirect_back_or  for you.  Also tidies up the session afterwards
  # If there has been a failed login attempt on some page using this method
  # you'll be redirected back to that page.  Otherwise redirect to the default_url
  #
  # To make sure you're not redirected back to the login page after a failed then successful login,
  # you can include an ignore url.  Basically, if the return url == the ignore url go to the default_url
  #
  # set the ignore url via an :ignore option in the opts hash.
  def redirect_back_or(default_url, opts = {})
    if session[:return_to] && session[:return_to] != opts[:ignore]
      redirect session[:return_to]
    else
      redirect default_url
    end
    session[:return_to] = nil
  end
  
end

class Application < Merb::Controller; end # Just to make sure we have an application controller handy
class Exceptions < Application
  after :_set_return_to, :only => :unauthenticated
  
  private 
  def _set_return_to
    session[:return_to] ||= request.uri unless request.exceptions.blank?
  end
end