require 'sinatra'
require 'json'
require_relative 'models/data_mapper'

set :views, settings.root + '/views'

# sets root as the parent-directory of the current file
#set :root, File.join(File.dirname(__FILE__), '..')
# sets the models directory
#set :models, Proc.new { File.join(root, "models") }
# sets the views directory
#set :views, Proc.new { File.join(root, "views") }

#End Points ------

# application root
get('/') do
  suburbs = Suburb.all
  erb(:index, locals: { suburbs: suburbs })
end

# render a search for suburb form
get('/suburbs/search') do
  erb(:search_suburb)
end
