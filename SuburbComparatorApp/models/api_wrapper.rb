require 'rubygems'
require 'httparty'

class APIWrapper
  include HTTParty
  base_uri "https://api.trademe.co.nz/v1/"

  def localities
    self.class.get('/Localities.json')
  end

  def rentals
    self.class.get('/Search/Property/Rental.json')
  end
end
