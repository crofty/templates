#====================
# Usage
#====================
# rails endless-rotation -m http://github.com/crofty/templates.git/recommend.rb --freeze --database=mysql

#====================
# TODO
#====================
# Edit user migration: remove password field and replace with a crypted_password field and a salt field.  Also add a persistence_token field
# Run rake db:migrate
# Change the user form so that it uses a password field and has a password confirmation field
# Change the destroy action of the user_sessions controller so the the find is done without an id UserSession.find

run "> README"

#====================
# GEMS
#====================
gem 'mislav-will_paginate',
  :lib => 'will_paginate',
  :source => 'http://gems.github.com',
  :version => '>= 2.3.5'
gem 'mocha'
gem 'thoughtbot-factory_girl',
  :lib => 'factory_girl',
  :source => 'http://gems.github.com',
  :version => '>= 1.2.0'
gem "authlogic"
#gem 'cucumber'
#gem 'webrat'

run 'haml --rails .'
rake "gems:install", :sudo => true
rake "gems:unpack"

#====================
# Generators
#====================
generate :cucumber
generate :nifty_layout
generate :nifty_scaffold, "user email:string password:string"
generate :session, "user_session"
generate :nifty_scaffold, "user_session --skip-model email:string password:string new destroy"
generate :controller, "home"

#====================
# User model
#====================
file 'app/models/user.rb',
%q{
class User < ActiveRecord::Base
  acts_as_authentic
end
}
file 'app/models/user.rb',
%q{
class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_email
end
}

#====================
# Application Controller
#====================
file 'app/controllers/application_controller.rb',
%q{
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  helper_method :current_user

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

end
}

#====================
# DATABASE
#====================
rake "db:create"

#====================
# Stylesheet
#====================
run "mkdir public/stylesheets/sass"
run "curl -L http://github.com/crofty/templates.git/public/stylesheets/reset.css > public/stylesheets/reset.css"
run "curl -L http://github.com/crofty/templates.git/public/stylesheets/sass/screen.sass > public/stylesheets/sass/screen.sass"

#====================
# JQuery
#====================
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"

#====================
# Routes
#====================
route "map.root :controller => 'home'"
route "map.login 'login', :controller => 'user_sessions', :action=> 'new' "
route "map.logout 'logout', :controller => 'user_sessions', :action=> 'destroy' "

# ====================
# FINALIZE
# ====================
run 'find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'
run "cp config/database.yml config/example_database.yml"
run "rm public/index.html"
git :init
git :add => "."
git :commit => "-m 'initial commit'"