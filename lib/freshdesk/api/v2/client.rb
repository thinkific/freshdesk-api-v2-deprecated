module Freshdesk
  module Api
    module V2
      class Client

        PATH = "api/v2/"
        COMPANIES = "companies"
        CONTACTS = "contacts"

        def initialize(base_url, api_key)
          @connection = Freshdesk::Api::V2::Connection.new(base_url, api_key)
        end

        #Contacts
        def get_contacts(args={})
          wrapped_in_json do
            @connection.get(CONTACTS, args)
          end
        end

        def find_contact_by_id(id)
          wrapped_in_json do
            @connection.get(CONTACTS, id.to_s)
          end
        end

        def create_contact(contact_attributes)
          wrapped_in_json do
            @connection.post(CONTACTS, contact_attributes.to_json)
          end
        end

        def update_contact(contact_id, contact_attributes)
          wrapped_in_json do
            @connection.put(CONTACTS, id.to_s, contact_attributes.to_json)
          end
        end

        #Companies
        def get_companies(args={})
          wrapped_in_json do
            @connection.get(COMPANIES, args)
          end
        end

        def find_company_by_id(id)
          wrapped_in_json do
            @connection.get(COMPANIES, id.to_s)
          end
        end

        def create_company(company_attributes)
          wrapped_in_json do
            @connection.post(COMPANIES, company_attributes.to_json)
          end
        end

        def update_company(id, company_attributes)
          wrapped_in_json do
            @connection.put(COMPANIES, id.to_s, company_attributes.to_json)
          end
        end

        private

          def wrapped_in_json(&block)
            result = block.call
            JSON.parse(result)
          end
      end
    end
  end
end
