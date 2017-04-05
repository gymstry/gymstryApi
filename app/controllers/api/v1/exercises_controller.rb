class Api::V1::ExercisesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member,contains: [:admin,:trainer]
  before_action :authenticate_member!, only: [:create,:update,:add_images,:destroy]
  before_action :set_exercise, only: [:show,:update,:destroy,:add_images]
  before_action only: [:index,:exercises_by_search,:exercises_by_ids,:exercises_by_not_ids,:exercises_with_images,:exercises_with_medical_records,:exercises_with_routines,:exercises_available_user,:exercises_by_workout_per_day] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:trainer_id)
      @exercises = Exercise.unscoped.load_exercises(exercise_pagination.merge(exercise_params: params[:exercise_params]))
        .search_by_trainer(params[:trainer_id])
    elsif params.has_key?(:workout_id)
      @exercises = Exercise.exercises_by_workout(params[:workout_id],exercise_pagination.merge(exercise_params: params[:exercise_params]))
    else
      @exercises = Exercise.load_exercises(exercise_pagination.merge(exercise_params: params[:exercise_params]))
    end
    render json: @exercises, status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  def show
    if @exercise
      if stale?(@exercise,public: true)
        render json: @exercise,status: :ok,:location => api_v1_exercy_path(@exercise), serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
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
      render json: @exercise,status: :ok,:location => api_v1_exercy_path(@exercise), serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
    else
      record_errors(@exercise)
    end
  end

  def upadte
    if @exercise
      if current_member.is_a?(Admin) || (current_member.id == @exercise.trainer_id)
        if @exercise.update(exercise_params)
          render json: @exercise,status: :ok,:location => api_v1_exercy_path(@exercise), serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
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
      if current_member.is_a?(Admin) || current_member.id == @exercies.trainer_id
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
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def exercises_by_search
    if params.has_key?(:q)
      if params.has_key?(:trainer_id)
        @exercises = Exercise.exercises_by_search(params[:q],exercise_pagination.merge(exercise_params: params[:exercise_params]))
          .search_by_trainer(params[:trainer_id])
      else
        @exercises = Exercise.exercises_by_search( params[:q],exercise_pagination.merge(exercise_params: params[:exercise_params]))
      end
      render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
    else
      q_not_found
    end
  end

  def exercises_by_ids
    @exercises = Exercise.exercises_by_ids(set_ids,exercise_pagination.merge(exercise_params: params[:exercise_params]))
    render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  def exercises_by_not_ids
    @exercises = Exercise.exercises_by_not_ids(set_ids,exercise_pagination.merge(exercise_params: params[:exercise_params]))
    render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  def exercises_with_images
    @exercises = Exercise.exercises_with_images(exercise_pagination.merge(exercise_params: params[:exercise_params]))
    render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  def exercises_with_medical_records
    @exercises = Exercise.exercises_with_medical_records(exercise_pagination.merge(exercise_params: params[:exercise_params]))
    render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  def exercises_with_routines
    @exercises = Exercise.exercises_with_medical_records(exercise_pagination.merge(exercise_params: params[:exercise_params]))
    render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  def exercises_available_user
    if params.has_key?(:user_id)
      medical_records = MedicalRecord.load_medical_records.search_by_user(params[:user_id])
      medical_record = medical_records.first
      if medical_record
        ids = medical_record.exercises.ids
      end
      ids ||= []
      if params.has_key?(:trainer_id)
        @exercises = Exercise.exercises_available_user(ids,exercise_pagination.merge({trainer: params[:trainer_id]}).merge(exercise_params: params[:exercise_params]))
      else
        @exercises = Exercise.exercises_available_user(ids,exercise_pagination.merge(exercise_params: params[:exercise_params]))
      end
      render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
    else
      user_needed
    end
  end

  def exercises_by_workout_per_day
    @exercises = Exercise.exercises_by_workout_per_day(params[:workout_id],exercise_pagination.merge({day: params[:day]}).merge(exercise_params: params[:exercise_params]))
    render json: @exercises,status: :ok, each_serializer: Api::V1::ExerciseSerializer,render_attribute: params[:exercise_params] || "all"
  end

  protected

  def set_ids
    if params.has_key?(:exercise)
      ids = params[:exercise][:ids].split(",")
    end
    ids ||= []
    ids
  end

  def exercise_pagination
    {page: @page,per_page: @per_page}
  end

  def set_exercise
    @exercise = Exercise.exercise_by_id(params[:id],{exercise_params: params[:exercise_params]})
  end

  def exercise_params
    params.require(:exercise).permit(:name,:description,:problems,:benefits,:muscle_group,:level,:elements => [])
  end

end
