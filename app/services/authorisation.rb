class Authorisation
  attr_reader :response, :authorised

  DFE_SIGN_IN_URL = "https://signin-test-papi-as.azurewebsites.net"
  DFE_SIGN_IN_PASSWORD = ""
  DFE_SIGN_IN_SERVICE_ID = "e348f7d4-93d9-4b43-9b78-c84d80c2f34c"
  DFE_SIGN_IN_SERVICE_ACCESS_ROLE_ID = "9DD4BC2B-EDD1-460F-A6D5-DD512F5C8ED9"

  def initialize(organisation_id:, user_id:)
    @authorised = false
  end

  def call
    response = connection.get("/services/#{DFE_SIGN_IN_SERVICE_ID}/organisations/FA460F7C-8AB9-4CEE-AAFF-82D6D341D702/users/05808793-5B21-4B6F-87E8-CF3EC66DF848")
    if response.success?
      body = JSON.parse(response.body)

      if body['roles'].select { |role| role['id'].eql?(DFE_SIGN_IN_SERVICE_ACCESS_ROLE_ID) }
        @authorised = true
      else
        not_authorised
      end
    else
      not_authorised
    end

    self
  end

  def authorised?
    @authorised
  end

  private

  def connection
    @connection ||= Faraday.new(DFE_SIGN_IN_URL, headers: headers)
  end

  def headers
    @headers ||= {
      'Authorization': "bearer #{generate_jwt_token}",
      'Content-Type': 'application/json'
    }
  end

  def generate_jwt_token
    payload = {
      iss: 'schooljobs',
      exp: (Time.now.getlocal + 60).to_i,
      aud: 'signin.education.gov.uk'
    }
    JWT.encode payload, DFE_SIGN_IN_PASSWORD, 'HS256'
  end
end
