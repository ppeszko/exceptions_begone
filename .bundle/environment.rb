require 'digest/sha1'

# DO NOT MODIFY THIS FILE
module Bundler
  FINGERPRINT = "9f655d7d490ccc8451007dcb28bd7f880a2aa04a"
  LOAD_PATHS = ["/Library/Ruby/Gems/1.8/gems/josevalim-rails-footnotes-3.6.2/lib", "/Library/Ruby/Gems/1.8/gems/nokogiri-1.4.1/lib", "/Library/Ruby/Gems/1.8/gems/nokogiri-1.4.1/ext", "/Library/Ruby/Gems/1.8/gems/thoughtbot-factory_girl-1.2.2/lib", "/Library/Ruby/Gems/1.8/gems/builder-2.1.2/lib", "/Library/Ruby/Gems/1.8/gems/activesupport-2.3.5/lib", "/Library/Ruby/Gems/1.8/gems/json_pure-1.2.0/lib", "/Library/Ruby/Gems/1.8/gems/redgreen-1.2.2/lib", "/Library/Ruby/Gems/1.8/gems/cucumber-rails-0.2.3/lib", "/Library/Ruby/Gems/1.8/gems/rack-1.1.0/lib", "/Library/Ruby/Gems/1.8/gems/webrat-0.6.0/lib", "/Library/Ruby/Gems/1.8/gems/database_cleaner-0.4.1/lib", "/Library/Ruby/Gems/1.8/gems/mislav-will_paginate-2.3.11/lib", "/Library/Ruby/Gems/1.8/gems/authlogic-2.1.3/lib", "/Library/Ruby/Gems/1.8/gems/diff-lcs-1.1.2/lib", "/Library/Ruby/Gems/1.8/gems/rspec-1.2.9/lib", "/Library/Ruby/Gems/1.8/gems/rspec-rails-1.2.9/lib", "/Library/Ruby/Gems/1.8/gems/polyglot-0.2.9/lib", "/Library/Ruby/Gems/1.8/gems/treetop-1.4.3/lib", "/Library/Ruby/Gems/1.8/gems/lukeredpath-simpleconfig-1.0.2/lib", "/Library/Ruby/Gems/1.8/gems/ruby-net-ldap-0.0.4/lib", "/Library/Ruby/Gems/1.8/gems/term-ansicolor-1.0.4/lib", "/Library/Ruby/Gems/1.8/gems/cucumber-0.6.1/lib"]
  AUTOREQUIRES = {:test=>["redgreen", "thoughtbot-factory_girl", "webrat", "cucumber", "rspec", "rspec-rails"], :default=>["authlogic", "mislav-will_paginate", "lukeredpath-simpleconfig", "ruby-net-ldap"], :development=>["josevalim-rails-footnotes"], :cucumber=>["cucumber-rails", "database_cleaner", "webrat", "rspec", "rspec-rails", "thoughtbot-factory_girl"]}

  def self.match_fingerprint
    print = Digest::SHA1.hexdigest(File.read(File.expand_path('../../Gemfile', __FILE__)))
    unless print == FINGERPRINT
      abort 'Gemfile changed since you last locked. Please `bundle lock` to relock.'
    end
  end

  def self.setup(*groups)
    match_fingerprint
    LOAD_PATHS.each { |path| $LOAD_PATH.unshift path }
  end

  def self.require(*groups)
    groups = [:default] if groups.empty?
    groups.each do |group|
      (AUTOREQUIRES[group] || []).each { |file| Kernel.require file }
    end
  end

  # Setup bundle when it's required.
  setup
end
