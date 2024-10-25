class LikeService
  def initialize(params, user)
    @sighting_id = params[:sighting_id]
    @user = user
  end

  def perform!
    ActiveRecord::Base.transaction do 
      _find_sighting
      _toggle_like
    end
  end

  private

  def _find_sighting
    @sighting = Sighting.find_by(id: @sighting_id)
    raise ActiveRecord::RecordNotFound, "Sighting was not found" unless @sighting
  end

  def _toggle_like
    like = Like.find_or_initialize_by(user: logged_in_user, sighting: @sighting)

    if like.persisted?
      like.destroy
      return nil
    else
      like.save
      return like
    end
  end
end