class Api::V1::ImagesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:admin,:gym,:trainer]
  before_action :authenticate_member!, only: [:create,:update,:destroy]
  before_action :set_image, only: [:show,:destroy,:update]
  before_action only: [:index,:images_by_ids,:images_by_not_ids] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:exercise_id)
      @images = Image.images_by_exercise(params[:exercise_id],image_pagination)
    elsif params.has_key?(:gym_id)
      @images = Image.images_by_gym(params[:gym_id],image_pagination)
    else
      @images = Image.load_images(image_pagination)
    end
    render json: @images,status: :ok
  end

  def show
    if @image
      if stale?(@image,public: true)
        render json: @image,status: :ok,:location => api_v1_image(@image)
      end
    else
      record_not_found
    end
  end

  def create
    if params.has_key?(:exercise_id)
      exercise = Exercise.find_by_id(params[:exercise_id])
      if current_member.is_a?(Admin) || (exercise && current_member.is_a?(Trainer) && exercise.trainer_id == current_member.id)
        create_by_resource(exercise)
      else
        operation_not_allowed
      end
    elsif params.has_key?(:gym_id)
      gym = Gym.find_by_id(params[:id])
      if gym && current_member.is_a?(Gym) && gym.id == current_member.id
        create_by_resource(gym)
      else
        operation_not_allowed
      end
    end
  end

  def update
    if @image
      if params.has_key?(:exercise_id)
        exercise = Exercise.find_by_id(params[:exercise_id])
        if current_member.is_a?(Trainer) && exercise && exercise.trainer_id == current_member.id
          if @image.update(image_params)
            render json: @image,status: :ok, :location => api_v1_image(@image)
          else
            record_errors(@image)
          end
        else
          operation_not_allowed
        end
      elsif params.has_key?(:gym_id)
        gym = Gym.find_by_id(params[:id])
        if current_member.is_a?(Gym) && gym && gym.id == current_member
          if @image.update(image_params)
            render json: @image,status: :ok, :location => api_v1_image(@image)
          else
            record_errors(@image)
          end
        else
          operation_not_allowed
        end
      end
    else
      record_not_found
    end
  end

  def destroy
    if @image
      if params.has_kye?(:exercise_id)
        excercise = Exercise.find_by_id(params[:exercise_id])
        if current_member.is_a?(Admin) || (exercise && current_member.is_a?(Trainer) && exercise.trainer_id == current_member.id)
          @image.destroy
          head :no_content
        else
          operation_not_allowed
        end
      elsif params.has_key?(:gym_id)
        gym = Gym.find_by_id(params[:gym_id])
        if current_member.is_a?(Admin) || (gym && current_member.is_a?(Gym) && current_member.id == gym.id)
          @image.destroy
          head :no_content
        else
          operation_not_allowed
        end
      end
    else
      record_not_found
    end
  end

  def images_by_ids
    @images = Image.images_by_ids(set_ids,image_pagination)
    render json: @images,status: :ok
  end

  def images_by_not_ids
    @images = Image.images_by_not_ids(set_ids,image_pagination)
    render json: @images,status: :ok
  end

  private
  def set_ids
    if params.has_key?(:image)
      ids = params[:image][:ids].split(",")
    end
    ids ||= []
    ids
  end

  def set_image
    @image = Image.image_by_id(params[:id])
  end

  def image_pagination
    {page: @page,per_page: @per_page}
  end

  def create_by_resource(resource)
    if resource
      @image = Image.new(image_params)
      resource.images << @image
      if @image.save
        resource.save
        render json @image,status: :create,:location => api_v1_image(@image)
      else
        record_errors(@image)
      end
    else
      resource_not_found
    end
  end


  def image_params
    params.require(:image).permit(:image,:description)
  end
end
