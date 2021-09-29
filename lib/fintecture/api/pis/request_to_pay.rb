# frozen_string_literal: true

require 'json'
require 'faraday'
require 'fintecture/endpoints/pis'
require 'fintecture/base_url'
module Fintecture
  module Pis
    class RequestToPay
      class << self
        # ------------ PUBLIC METHOD ------------
        def generate(client, payload = nil, x_language, redirect_uri)
          @client = client

          # Do the _request request
          _request payload, x_language, redirect_uri
        end

        private

        # ------------ REQUEST ------------
        def _request(payload, x_language, redirect_uri)
          # Get the url request
          url = request_to_pay_endpoint

          # Build uri params
          query_string = ''
          if redirect_uri
            params = {}
            params['redirect_uri'] = redirect_uri
            query_string = "?#{params.map { |key, value| "#{key}=#{value}" }.join('&')}"
          end

          # Build additional headers
          additional_headers = {}
          additional_headers['x-language'] = x_language

          # Do connect request
          Fintecture::Faraday::Authentication::Connection.post(
            url: url + query_string,
            req_body: payload.to_json,
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true,
            additional_headers: additional_headers
          )
        end

        # ------------ API ENDPOINT ------------
        def request_to_pay_endpoint
          "#{api_base_url}/#{Fintecture::Api::Endpoints::Pis::REQUEST_TO_PAY}"
        end

        # ------------ BASE URL ------------
        def api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

        # ------------ TOOLS ------------
        def as_json(element)
          return JSON(element.to_json) if element.is_a? Hash

          begin
            element.as_json
          rescue NoMethodError
            raise Fintecture::ValidationException,
                  "invalid parameter format, the parameter should be a Hash or an Object Model instead a #{element.class.name}"
          end
        end
      end
    end
  end
end
