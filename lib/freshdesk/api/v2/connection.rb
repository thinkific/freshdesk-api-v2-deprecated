require 'rest-client'

module Freshdesk
  module Api
    module V2
      class Connection

        def initialize(base_url, api_key)
          @base_url = base_url
          @auth = {user: api_key, password: "X"}
        end

        def get(endpoint, args={})
          url = construct_url(endpoint)
          with_exception_handling do
            RestClient::Request.execute(@auth.merge(
              headers: { params: args },
              method: :get,
              url: url))
          end
        end

        def put(endpoint, id, attributes)
          url = construct_url(endpoint, id)
          with_exception_handling do
            RestClient::Request.execute(@auth.merge(
              payload: attributes,
              headers: {content_type: "application/json"},
              method: :put,
              url: url))
          end
        end

        def post(endpoint, attributes)
          url = construct_url(endpoint)
          with_exception_handling do
            RestClient::Request.execute(@auth.merge(
              payload: attributes,
              headers: {content_type: "application/json"},
              method: :post,
              url: url))
          end
        end

        def delete(endpoint, id)
          url = construct_url(endpoint, id)
          with_exception_handling do
            RestClient::Request.execute(@auth.merge(method: :delete, url: url))
          end
        end

        private

          def with_exception_handling(&block)
            begin
              block.call
            rescue RestClient::UnprocessableEntity
              raise AlreadyExistedError, "Entity already exists"
            rescue RestClient::InternalServerError
              raise ConnectionError, "Connection to the server failed."
            rescue RestClient::Found
              raise ConnectionError, "Connection to the server failed. Please check username/password"
            rescue Exception
              raise
            end
          end

          def construct_url(endpoint, id=nil)
            base = @base_url.end_with?("/") ? @base_url : "#{@base_url}/"
            endpoint = endpoint.end_with?("/") ? endpoint : "#{endpoint}/"
            url = "#{base}api/v2/#{endpoint}#{id}"
            if url.end_with?("/")
              url = url.slice(0, url.length - 1)
            end
            url
          end

      end
    end
  end
end
