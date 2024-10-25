module ThirdParty
  class TriviaApiService < ThirdParty::Base
    API_URL = "https://opentdb.com/api.php?amount=1&category=18&difficulty=medium"

    def fetch_question
      response = request(API_URL, amount: 1, category: 18, difficulty: 'medium')

      return handle_error(response['response_code']) if response['response_code'] != 0

      parse_response(response)
    end

    private

    def parse_response(response)
      results = response['results']
      
      results.first['question']
    end

    def handle_error(response_code)
      case response_code
      when 1
        raise StandardError, "Could not return results"
      when 2
        raise StandardError, "Invalid parameter"
      when 3
        raise StandardError, "Token Not Found"
      when 4
        raise StandardError, "Token Empty"
      when 5
        raise StandardError, "Rate Limit"
      else
        raise StandardError, "Unknown error"
      end
    end
  end
end