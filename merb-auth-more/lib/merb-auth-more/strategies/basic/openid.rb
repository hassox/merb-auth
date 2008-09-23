# The openid strategy attempts to login users based on the OpenID protocol 
# http://openid.net/
# 
# Overwrite the on_sucess!, on_failure!, on_setup_needed!, and on_cancel! to customize events.
#
# Overwite the required_reg_fields method to require different sreg fields.  Default is email and nickname
#
# Overwrite the openid_store method to customize your session store
#
# == Requirments
#
# === Routes:
#   :openid - an action that is accessilbe via http GET and protected via ensure_authenticated
#   :signup - a url accessed via GET that takes a user to a signup form (overwritable)
#
# === Attributes
#   :identity_url - A string for holding the identity_url associated with this user (overwritable)
#
require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/sreg'

class Authentication
  module Strategies
    module Basic
      class OpenID < Base
        def run!
          if params[:'openid.mode']
            response = consumer.complete(request.send(:query_params), "#{request.protocol}://#{request.host}" + request.path)
            if response.status.to_s == 'success'
              sreg_response = ::OpenID::SReg::Response.from_success_response(response)
              result = on_success!(response, sreg_response)
              Merb.logger.info "\n\n#{result.inspect}\n\n"
              result
            elsif response.status.to_s == 'failure'
              on_failure!(response)
            elsif response.status.to_s == 'setup_needed'
              on_setup_needed!(response)
            elsif response.status.to_s == 'cancel'
              on_cancel!(response)
            end
          elsif identity_url = params[:openid_url]
            begin
              openid_request = consumer.begin(identity_url)
              openid_reg = ::OpenID::SReg::Request.new
              openid_reg.request_fields(required_reg_fields)
              openid_request.add_extension(openid_reg)
              throw(:halt, lambda{ redirect(openid_request.redirect_url("#{request.protocol}://#{request.host}", absolute_url(:openid)) )})
            rescue ::OpenID::OpenIDError => e
              request.session.authentication.errors.clear!
              request.session.authentication.errors.add(:openid, 'The OpenID verification failed')
              nil
            end
          end
        end # run!
        
        
        # Overwrite the on_success! method with the required behavior for successful logins
        def on_success!(response, sreg_response)
          if user = find_user_by_identity_url(response.identity_url)
            user
          else
            request.session[:'openid.url'] = response.identity_url
            required_reg_fields.each do |f|
              session[:"openid.#{f}"] = sreg_response.data[f] if sreg_response.data[f]
            end if sreg_response
            throw(:halt, request.redirect(request.generate_url(:signup)))
          end
        end
        
        # Overwrite the on_failure! method with the required behavior for failed logins
        def on_failure!(response)
          session.authentication.errors.clear!
          session.authentication.errors.add(:openid, 'OpenID verification failed, maybe the provider is down? Or the session timed out')
          nil
        end
        
        def on_setup_needed!(response)
          request.session.authentication.errors.clear!
          request.session.authentication.errors.add(:openid, 'OpenID does not seem to be configured correctly')
          nil
        end
        
        def on_cancel!(response)
          request.session.authentication.errors.clear!
          request.session.authentication.errors.add(:openid, 'OpenID rejected our request')
          nil
        end
        
        def required_reg_fields
          ['nickname', 'email']
        end
        
        # Overwrite this to support an ORM other than DataMapper
        def find_user_by_identity_url(url)
          user_class.first(:identity_url => url)
        end
        
        # Overwrite this method to set your store
        def openid_store
          ::OpenID::Store::Filesystem.new("#{Merb.root}/tmp/openid")
        end
        
        private 
        def consumer
          @consumer ||= ::OpenID::Consumer.new(request.session, openid_store)
        end
              
      end # OpenID
    end # Basic
  end # Strategies
end # Authentication