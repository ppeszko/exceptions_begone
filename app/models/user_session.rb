class UserSession < Authlogic::Session::Base
  
  verify_password_method :valid_ldap_credentials? # if AUTHLOGIC_ADDON == "ldap"
  
  # def self.login_field
  #   :username
  # end
  # 
  # def self.password_field
  #   :crypted_password
  # end
  
end