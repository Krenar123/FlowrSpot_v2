module ThirdParty
  class Base
    def request(api_url, options = {})
      uri = URI(api_url)
      uri.query = URI.encode_www_form(options) if options.present?

      reponse = Net::HTTP.get_response(uri)
      handle_response(response)
    end

    private

    def handle_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response)
      else
        raise StandardError, "HTTP request failed: #{response.message} (#{response.code})"
      end
    end
  end
end
