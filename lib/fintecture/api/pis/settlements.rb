# frozen_string_literal: true

require 'json'
require 'faraday'
require 'fintecture/endpoints/pis'
require 'fintecture/base_url'

module Fintecture
  module Pis
    class Settlements
      class << self
        # ------------ PUBLIC METHOD ------------
        def get(client, settlement_id)
          @client = client

          # Do the get_payments request
          _request settlement_id
        end

        private

        # ------------ REQUEST ------------
        def _request(settlement_id)
          url = _endpoint

          Fintecture::Faraday::Authentication::Connection.get(
            url: "#{url}/#{settlement_id}",
            client: @client,
            custom_content_type: 'application/json',
            bearer: "Bearer #{@client.token}",
            secure_headers: true
          )
        end

        # ------------ API ENDPOINT ------------
        def _endpoint
          "#{_api_base_url}/#{Fintecture::Api::Endpoints::Pis::SETTLEMENTS}"
        end

        # ------------ BASE URL ------------
        def _api_base_url
          Fintecture::Api::BaseUrl::FINTECTURE_API_URL[@client.environment.to_sym]
        end

      end
    end
  end
end