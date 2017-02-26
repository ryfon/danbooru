set :user, "ryfon"
set :rails_env, "production"
server "192.168.1.105", :roles => %w(web app db), :primary => true, :user => "ryfon"
#server "hijiribe.donmai.us", :roles => %w(web app), :user => "albert"

set :linked_files, fetch(:linked_files, []).push(".env.production")
