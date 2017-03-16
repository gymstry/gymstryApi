class Api::V1::ExercisesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member,contains: [:admin,:trainer]
  before_action :authenticate_member!, only: [:create,:update,:add_images,:destroy]
  before_action :set_exercise, only: [:show,:update,:destroy,:add_images]
  before_action only: [:index] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:trainer_id)
      @exercises = Exercise.unscoped.load_exercises(@page,@per_page)
        .search_by_trainer(params[:trainer_id])
    else
      @exercises = Exercise.load_exercises(@page,@per_page)
    end
    render json: @exercises, status: :ok
  end

  def show
    if @exercise
      if stale?(@exercise,public: true)
        render json: @exercise,status: :ok,:location => api_v1_exercy(@exercise)
      end
    else
      record_not_found
    end
  end

  def create
    @exercise = Exercise.new(exercise_params)
    if current_member.is_a?(Admin)
      @exercise.owner = "admin"
    else
      @exercise.owner = "trainer"
    end
    if @exercise.save
      render json: @exercise,status: :ok,:location => api_v1_exercy(@exercise)
    else
      record_errors(@exercise)
    end
  end

  def upadte
    if @exercise
      if current_member.is_a?(Admin) || (current_member.id == @exercise.trainer_id)
        if @exercise.update(exercise_params)
          render json: @exercise,status: :ok,:location => api_v1_exercy(@exercise)
        else
          record_errors(@exercise)
        end
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def destroy
    if @exercise
      if current_member.is_a?(Admin) || (current_member.id == @exercise.trainer_id)
        @exercise.destroy
        head :no_content
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def add_images
    if @exercise
      if params.has_key?(:image)
        images = params[:image][:images]
        descriptions = params[:image][:descriptions]
        images.each_with_index do |val,index| 
          image = Image.new(image: images[index],description: description[index])
          @exercise.images << image
          image.save
        end
        if @exercise.save
          head :no_content
        else
          record_errors(@exercise)
        end
      else
        images_needed
      end
    else
      record_not_found
    end
  end


  protected

  def set_exercy
    @exercise = Exercise.exercise_by_id(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:name,:description,:problems,:benefits,:muscle_group,:level,:elements => [])
  end

end
