# run with: rails demos -m demos_template.rb --database=mysq
load_template "http://github.com/crofty/templates.git/base_template.rb"

#====================
# Scaffolding
#====================
generate :controller, "home index"
route "map.root :controller => 'home', :action => 'index'"

generate :controller, "admin/home index"
route "map.admin 'admin', :controller => 'admin/home', :action => 'index'"

generate :rspec_haml_scaffold, "Project title:string summary:text overview:text times_viewed:integer active:boolean live:boolean"
generate :rspec_haml_scaffold, "admin/project  -f --skip-migration  title:string summary:text overview:text times_viewed:integer active:boolean live:boolean"
generate :model, "ProjectPublication project_id:integer publication_id:integer"

generate :model, "ProjectProgramme project_id:integer programme_id:integer"
generate :model, "ProjectFunder    project_id:integer funder_id:integer"
generate :model, "ProjectEvent     project_id:integer event_id:integer"
generate :model, "ProjectPerson    project_id:integer person_id:integer"

generate :rspec_haml_scaffold, "Programme name:string"
generate :rspec_haml_scaffold, "admin/programme -f --skip-migration  name:string"

generate :rspec_haml_scaffold, "Publication title:string published_date:date overview:text further_text:text isbn:string cost:decimal publication_type_id:integer live:boolean"
generate :rspec_haml_scaffold, "admin/publication -f --skip-migration title:string published_date:date overview:text further_text:text isbn:string cost:decimal publication_type_id:integer live:boolean" 
generate :model, "PublicationType type:string"

generate :rspec_haml_scaffold, "Person first_name:string last_name:string short_description:text overview_text:text telephone_no:string email:string"
generate :rspec_haml_scaffold, "admin/person -f --skip-migration first_name:string last_name:string short_description:text overview_text:text telephone_no:string email:string"

generate :model, "PersonPublication person_id:integer publication_id:integer"
generate :model, "PersonStaffType person_id:integer staff_type_id:integer"
generate :model, "StaffType type:string"

generate :rspec_haml_scaffold, "Funder name:string"
generate :rspec_haml_scaffold, "admin/funder -f --skip-migration name:string"

generate :rspec_haml_scaffold, "Event title:string datetime:datetime location:string featured:boolean"
generate :rspec_haml_scaffold, "admin/event -f --skip-migration title:string datetime:datetime location:string featured:boolean"
generate :model, "EventFunder event_id:integer funder_id:integer"
generate :model, "EventPerson event_id:integer person_id:integer"

#Restful Authentication
generate :authenticated, "user sessions --rspec "


#====================
# DATABASE
#====================
rake "db:create"
rake "db:migrate"
rake "db:test:clone"

# ====================
# Commit
# ====================
git :add => "."
git :commit => "-m 'structure made'"