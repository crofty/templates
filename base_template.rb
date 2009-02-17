run "> README"

#====================
# PLUGINS
#====================
plugin "rspec", :git => "git://github.com/dchelimsky/rspec.git"
plugin "rspec-rails", :git => "git://github.com/dchelimsky/rspec-rails.git"
generate :rspec
plugin "make_resourceful", :git => "git://github.com/hcatlin/make_resourceful.git"
# Use cnaths fork of Restful Authentication as it allows emails to be used instead of logins and the views are HAML 
plugin "restful_authentication", :git => "git://github.com/crofty/restful-authentication-with-email.git"
plugin "rspec_haml_scaffold_generator", :git => "git://github.com/crofty/rspec-haml-scaffold-generator.git"

# ====================
# CONFIG
# ====================
capify!

#====================
# GEMS
#====================
gem 'mislav-will_paginate',
  :lib => 'will_paginate',
  :source => 'http://gems.github.com',
  :version => '~> 2.3.5'
gem 'thoughtbot-factory_girl',
  :lib => 'factory_girl',
  :source => 'http://gems.github.com',
  :version => '>= 1.1.3'
gem 'thoughtbot-shoulda',
  :lib => 'shoulda',
  :source => 'http://gems.github.com',
  :version => '>= 2.0.5'
gem 'cucumber'

run 'haml --rails .'
rake "gems:install", :sudo => true
rake "gems:unpack"

#====================
# DATABASE
#====================
rake "db:create"
rake "db:migrate"
rake "db:test:clone"

#====================
# GIT
#====================
file ".gitignore", <<-END
.DS_STORE
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

#====================
# Rspec
#====================

file 'spec/spec_helper.rb',
%q{ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require 'factory_girl'

Spec::Runner.configure do |config|
  # If you are not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end


def table_has_columns(clazz, type, *column_names)
  column_names.each do |column_name|
    column = clazz.columns.select {|c| c.name == column_name.to_s}.first
    it "has a #{type} named #{column_name}" do
      column.should_not be_nil
      column.type.should == type.to_sym
    end
  end
end

def route_matches(path, method, params)
  it "maps #{params.inspect} to #{path.inspect}" do
    route_for(params).should == {:path => path, :method => method}
  end

  it "generates params #{params.inspect} from #{method.to_s.upcase} to #{path.inspect}" do
    params_from(method.to_sym, path).should == params
  end
end
}


#====================
# JQuery
#====================
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.1.min.js > public/javascripts/jquery.js"

#====================
# Stylesheet
#====================
run "mkdir public/stylesheets/sass"
run "curl -L http://github.com/crofty/templates.git/public/stylesheets/reset.css > public/stylesheets/reset.css"
run "curl -L http://github.com/crofty/templates.git/public/stylesheets/sass/screen.sass > public/stylesheets/sass/screen.sass"

#====================
# Layouts
#====================
run "curl -L http://github.com/crofty/templates.git/app/views/layouts/application.html.haml > app/views/layouts/application.html.haml"
run "curl -L http://github.com/crofty/templates.git/app/views/layouts/_head.html.haml > app/views/layouts/_head.html.haml"

# ====================
# FINALIZE
# ====================

run 'find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'
run "cp config/database.yml config/example_database.yml"
run "rm public/index.html"
git :init
git :add => "."
git :commit => "-m 'initial commit'"