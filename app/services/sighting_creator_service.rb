class SightingCreatorService
  def initialize(params, user, flower)
    @user = user
    @params = params
    @creator_params = params.merge(flower: flower, user: user)
  end

  def perform!
    ActiveRecord::Base.transaction do
      _create_sighting
      _update_sighting_question
    end
  end

  private

  def _create_sighting
    @sighting = Sighting.create!(@creator_params)
  end

  def _update_sighting_question
    UpdateQuestionJob.perform_later(@sighting)
  end
end