class TripsController < ApplicationController

  def index
    airport_codes =  %w(LAX)

    airport_codes.each do |airport|
      p "THIS IS THE AIRPORT => #{airport}"
      request = {
        "request" => {
          "maxPrice" => "USD" + params['sale_total'],
          "slice" => [
            {
              "origin" => params['origin'],
              "destination" => airport,
              "date" => params['depart_time']
            }
            ],
            "passengers" => {
              "adultCount" => 1
              },
              "solutions" => 1,
              "refundable" => false
            }
            }.to_json

      p @response = HTTParty.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyB9sDMOUjCNYYrn4K0A_CxPmEF7v2k741g",
        body: request,
        headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json' })

        def find_origin_city(params)
          x = []
          @response['trips']['data']['city'].each { |el| x << el if el.has_value?(params) }
          return x[0]['name']
        end

        # def find_destination_airport_code(airport_code)
        #   x = []
        #   @response['trips']['data']['city'].each { |el| p el x << el if el.has_value?(airport_code) }
        #   p x
        #   return x[0]['code']
        # end


        def find_city(airport)
          hash_containing_city_code = @response['trips']['data']['city'].select { |hash| hash.has_value?(find_city_code(airport)) }
          return hash_containing_city_code[0]['name']
        end

        def find_city_code(airport)
          @response['trips']['data']['airport'].select { |hash| hash.has_value?(airport) }[0]['city']
        end


        counter = 0
        # while counter < airport_codes.length
        # 2.times do

          # ERROR HANDLING
          # if @response['trips']['data']['airport'] == nil
          #   @error = 'No flight found with this search'
          # elsif @response['trips']['tripOption'][counter] == nil
          #   @error
          # else
          @duration = @response['trips']['tripOption'][counter]['slice'][0]['duration']
          @depart_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].first['leg'][0]['departureTime']
          @arrival_time = @response['trips']['tripOption'][counter]['slice'][0]['segment'].last['leg'][0]['arrivalTime']
          @carrier = @response['trips']['data']['carrier'][counter]['name']
          @sale_total = @response['trips']['tripOption'][counter]['saleTotal'].reverse.chomp('DSU').reverse.to_f
          @carrier_code = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['carrier']
          @flight_number = @response['trips']['tripOption'][0]['slice'][0]['segment'][counter]['flight']['number']
          # # p @mileage =
          @origin = find_origin_city(params['origin'])


          # These are not correct
          @destination_code = airport
          @destination = find_city(airport)

          # counter += 1
          # end
        # end

      Trip.create(sale_total: @sale_total, carrier: @carrier, carrier_code: @carrier_code, flight_number: @flight_number, depart_time: @depart_time, arrival_time: @arrival_time, duration: @duration, mileage: @mileage, origin: @origin, destination: @destination, destination_code: @destination_code)

    end
    # p "*" * 100
    # p @response

    @trips = Trip.all
    render json: @trips
  end
end









