class Api::V2::SightingsController < ApplicationController
    before_action :authorized, except: :index
    before_action :find_flower, only: [:index, :create]

    def index
        render json: { flower: @flower, sightings: @flower.sightings }
    end
    
    def create
        sighting_creator = SightingCreatorService.new(sighting_params, logged_in_user, @flower)
        result = sighting_creator.perform!
        
        # Reload flower to ensure it has the latest sightings
        @flower.reload
        
        render json: { flower: @flower, sightings: @flower.sightings }
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

    def destroy
        sighting = Sighting.find(params[:id])

        if same_sight_user?(sighting.user)
            if sighting.destroy
                render json: { note: 'Destroyed successfully!' }
            else
                render json: { note: 'Something went wrong!' }
            end
        else
            render json: {note: 'You dont have permission!!'}
        end
    end

    def toggle_like
        like_service = LikeService.new(params[:id], logged_in_user)
        result = like_service.perform!
        if result.nil?
            render json: { note: 'Like destroyed' }, status: :ok
        else
            render json: { note: 'Like created', result: result }, status: :ok
        end
    rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
    end

    private

    def find_flower
        @flower = Flower.find(params[:flower_id])
    rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
    end

    def sighting_params
        params.permit(:longitude, :latitude, :image)
    end
end
