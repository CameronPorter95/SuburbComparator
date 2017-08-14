require 'sinatra'
require 'json'
require 'data_mapper'
require_relative "api_wrapper"

set :bind, '127.0.0.1'
set :port, 27182

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/models/suburb-comparator.db")

class Region
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :name, Text, required: true

  has n, :suburbs, :constraint => :destroy
end

class Suburb
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :name, Text, required: true
  property :region_id, Integer, required: true

  has n, :rentals, :constraint => :destroy
  belongs_to :region
end

class Rental
  include DataMapper::Resource

  property :id, Integer, :key => true
  property :title, Text, required: true
  property :address, Text, required: false
  property :price, Text, required: false
  property :suburb_id, Integer, required: true

  belongs_to :suburb
end

DataMapper.finalize()
DataMapper.auto_upgrade!()

class DatabaseInsert
  @@apiWrapper = APIWrapper.new

  def createRegions
    regionArray = @@apiWrapper.localities
    regionArray.each do |regionJSON|
      new_region = Region.new
      new_region.id = "#{regionJSON["LocalityId"]}"
      new_region.name = "#{regionJSON["Name"]}"
      new_region.save
    end
  end

  def createSuburbs
    regionArray = @@apiWrapper.localities
    regionArray.each do |regionJSON|
      regionId = "#{regionJSON["LocalityId"]}"
      districtArray = regionJSON["Districts"]
      districtArray.each do |districtJSON|
        suburbArray = districtJSON["Suburbs"]
        suburbArray.each do |suburbJSON|
          new_suburb = Suburb.new
          new_suburb.id = "#{suburbJSON["SuburbId"]}"
          new_suburb.name = "#{suburbJSON["Name"]}"
          new_suburb.region_id = regionId
          new_suburb.save
        end
      end
    end
  end

#  def createSensors
#    @@apiWrapper.sensors.each do |sensor|

#    end
#  end
end

databaseInserter = DatabaseInsert.new
databaseInserter.createRegions
databaseInserter.createSuburbs
