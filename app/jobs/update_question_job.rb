class UpdateQuestionJob < ApplicationJob
  retry_on Net::OpenTimeout, Timeout::Error, wait: 5.seconds 

  def perform!(sighting)
    question = ThirdParty::TriviaApiService.fetch_question

    sighting.update(question: question) if question.present?
  rescue Net::OpenTimeout, Timeout::Error => e
    Rails.logger.error("Network error occured while fetching trivia question: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Failed to update sighting: #{sighting.id}: #{e.message}")
  end
end
