require 'net/ldap'
class User
  include MongoMapper::Document

  include Authlogic::ActsAsAuthentic::Base
  include Authlogic::ActsAsAuthentic::Email
  include Authlogic::ActsAsAuthentic::LoggedInStatus
  include Authlogic::ActsAsAuthentic::Login
  include Authlogic::ActsAsAuthentic::MagicColumns
  include Authlogic::ActsAsAuthentic::Password
  include Authlogic::ActsAsAuthentic::PerishableToken
  include Authlogic::ActsAsAuthentic::PersistenceToken
  include Authlogic::ActsAsAuthentic::RestfulAuthentication
  include Authlogic::ActsAsAuthentic::SessionMaintenance
  include Authlogic::ActsAsAuthentic::SingleAccessToken
  include Authlogic::ActsAsAuthentic::ValidationsScope
  
  key :crypted_password
  key :current_login_at
  key :email
  key :last_login_at
  key :password_salt
  key :persistence_token
  key :username
  timestamps!

  many :stacks
  
  acts_as_authentic do |authlogic|
    authlogic.validate_password_field = false if AUTHLOGIC_ADDON == "ldap"
  end

  protected
    def valid_ldap_credentials?(password_plaintext)
      # add your ldap configuration here
      ldap = Net::LDAP.new
      ldap.host = "your host name"
      ldap.port = 636 #required for SSL connections, 389 is the default plain text port
      ldap.encryption :simple_tls #also required to tell Net:LDAP that we want SSL
      ldap.base = "your base settings" 

      ldap.auth "#{self.username}@your_host","#{password_plaintext}"
      ldap.bind # will return false if authentication is NOT successful
    end
end
