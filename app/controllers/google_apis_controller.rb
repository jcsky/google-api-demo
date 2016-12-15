class GoogleApisController < ApplicationController
  include Rails.application.routes.url_helpers
  require 'google/apis/people_v1'
  require 'google/api_client/client_secrets'

  def index
    #code
  end

  def people_auth
    set_google_api_service
    fetch_code_url = @service.authorization.authorization_uri.to_s
    redirect_to fetch_code_url
  end

  def people_callback
    @code = params[:code]
    @id = 0
    set_google_api_service
    @people_data = []
    has_next_data = true
    while has_next_data do
      has_next_data = fetch_people(@next_page_token)
    end
  end

  private

  def set_google_api_service
    authorization = Google::APIClient::ClientSecrets.load(
      File.join(
        Rails.root,
        'config',
        'client_secret.json'
      )
    ).to_authorization
    authorization.scope = Google::Apis::PeopleV1::AUTH_CONTACTS_READONLY
    authorization.grant_type = "authorization_code"
    authorization.redirect_uri = people_callback_google_apis_url
    authorization.code = @code

    @service = Google::Apis::PeopleV1::PeopleService.new
    @service.authorization = authorization
  end

  def fetch_people(page_token)
    response = @service.list_person_connections(
      'people/me',
      page_size: 500,
      page_token: page_token,
      request_mask_include_field: "person.names,person.emailAddresses,person.photos"
    )
    @next_page_token = response.next_page_token
    people = response.connections
    save_people_data(people)
    return !(response.connections.empty? or @next_page_token.blank?)
  end

  def save_people_data(people)
    people.each{ |person|
      @people_data << {
                        id: @id,
                        email: person.email_addresses.try(:first).try(:value),
                        name: person.names.try(:first).try(:display_name),
                        photo: person.photos.try(:first).try(:url)
                      }
      @id += 1
    }
  end

end
