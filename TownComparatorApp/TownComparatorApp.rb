require 'sinatra'
require 'json'

set :bind, '127.0.0.1'
set :port, 31415
set :views, settings.root + '/html'

require 'data_mapper'

DataMapper.setup(:default, 'sqlite:town-amenities.db')

class Town
  include DataMapper::Resource

  property :id, Serial
  property :name, Text, required: true
  property :description, Text, required: true

  has n, :amenities, :constraint => :destroy
end

class Amenity
  include DataMapper::Resource

  property :id, Serial
  property :name, Text, required: true
  property :description, Text, required: true
  property :town_id, Integer, required: true

  belongs_to :town
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

#End Points ------

# application root
get('/') do
  towns = Town.all
  erb(:index, locals: { towns: towns })
end

# render a create town form
get('/towns/create') do
  erb(:create_town)
end

# create a new town
post('/towns') do
  new_town = Town.new
  new_town.name = params[:name]
  new_town.description = params[:description]
  new_town.save
  redirect('/')
end
