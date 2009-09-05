#====================
# Usage
#====================
# rails hmtpng -m http://github.com/crofty/templates.git/hmtpng.rb

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
gem 'RedCloth', :lib => 'redcloth', :version => '~> 3.0.4'
gem 'mislav-will_paginate',
  :lib => 'will_paginate',
  :source => 'http://gems.github.com',
  :version => '>= 2.3.5'
gem 'mocha'
gem 'thoughtbot-factory_girl',
  :lib => 'factory_girl',
  :source => 'http://gems.github.com',
  :version => '>= 1.2.0'
gem 'thoughtbot-shoulda',
  :lib => 'shoulda',
  :source => 'http://gems.github.com',
  :version => '>= 2.0.5'
gem "authlogic"
gem 'cucumber'
gem 'webrat'

run 'haml --rails .'
rake "gems:install", :sudo => true
rake "gems:unpack"

#====================
# Generators
#====================
generate :cucumber
generate :nifty_layout
generate :nifty_scaffold, "user email:string password:string new edit"
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
route "map.login 'logout', :controller => 'user_sessions', :action=> 'destroy' "

# ====================
# FINALIZE
# ====================
run 'find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'
run "cp config/database.yml config/example_database.yml"
run "rm public/index.html"
git :init
git :add => "."
git :commit => "-m 'initial commit'"