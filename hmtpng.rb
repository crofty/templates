
#====================
# TODO
#====================
# Add the HOST constant to each of the environment files



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
gem 'thoughtbot-quietbacktrace'
gem "thoughtbot-clearance",
  :lib     => 'clearance',
  :source  => 'http://gems.github.com',
  :version => '0.8.2'
gem 'cucumber'
gem 'webrat'

run 'haml --rails .'
rake "gems:install", :sudo => true
rake "gems:unpack"

#====================
# Generators
#====================
generate :clearance
generate :cucumber

#====================
# DATABASE
#====================
rake "db:create"
rake "db:migrate"
rake "db:test:clone"

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

#====================
# JQuery
#====================
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"

# ====================
# FINALIZE
# ====================
run 'find . \( -type d -empty \) -and \( -not -regex ./\.git.* \) -exec touch {}/.gitignore \;'
run "cp config/database.yml config/example_database.yml"
run "rm public/index.html"
git :init
git :add => "."
git :commit => "-m 'initial commit'"