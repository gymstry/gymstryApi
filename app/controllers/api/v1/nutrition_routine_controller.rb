class Api::V1::NutritionRoutineController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:admin,:trainer]
  before_action :authenticate_member!, only: [:destroy]
  before_action :set_nutrition_routine, only: [:show,:update,:destroy]
  before_action :authenticate_trainer!, only: [:create,:update]
  before_action only: [:index,:nutrition_routines_by_name,:nutrition_routines_by_ids,:nutrition_routines_by_not_ids,:nutrition_routines_by_start_date,:nutrition_routines_by_end_date,:nutrition_routine_with_food_day] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_user_and_trainer_id(params[:user_id],nutrition_routine_pagination.merge(trainer: params[:trainer_id]))
    elsif params.has_key?(:trainer_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_trainer_id(params[:user_id],nutrition_routine_pagination)
    elsif params.has_key?(:user_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_user_id(params[:user_id],nutrition_routine_pagination)
    else
      @nutrition_routines = NutritionRoutine.load_nutrition_routines(nutrition_routine_pagination)
    end
    render json: @nutrition_routines,status: :ok
  end

  def show
    if @nutrition_routine
      if stale?(@nutrition_routine,public: true)
        render json: @nutrition_routine,status: :ok, :location => api_v1_nutrition_routine(@nutrition_routine)
      end
    else
      record_not_found
    end
  end

  def create
    @nutrition_routine = NutritionRoutine.new(nutrition_routine_params)
    user = User.user_by_id(params[:user_id])
    if user && current_trainer.branch.id == user.branch.id
      @nutrition_routine.trainer_id = current_trainer.id
      @nutrition_routine.user_id = user.id
      if @nutrition_routine.save
        if params.has_key?(:food_days)
          add_food_days(params[:food_days],@nutrition_routine)
          @nutrition_routine.save
        end
        render json: @nutrition_routine,status: :created, :location => api_v1_nutrition_routine(@nutrition_routine)
      else
        record_errors(@nutrition_routines)
      end
    else
      traniner_and_user
    end
  end

  def update
    if @nutrition_routine
      @nutrition_routine.trainer_id =  @nutrition_routine.trainer ?   @nutrition_routine.trainer_id : current_trainer.id
      if @nutrition_routine.trainer_id == current_trainer
        if @nutrition_routine.update(nutrition_routine_params)
          if params.has_key?(:food_days)
            add_food_days(params[:food_days],@nutrition_routine)
            @nutrition_routine.save
          end
          render json: @nutrition_routine,status: :ok, :location => api_v1_nutrition_routine(@nutrition_routine)
        end
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def destroy
    if @nutrition_routine
      if current_member.is_a?(Admin) || (!@nutrition_routine.trainer || @nutrition_routine.trainer_id == current_member.id)
        @nutrition_routine.destroy
        head :no_content
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def nutrition_routines_by_name
    @nutrition_routines = NutritionRoutine.nutrition_routines_by_name(params[:name] || "", nutrition_routine_pagination)
    render json: @nutrition_routines, status: :ok
  end

  def nutrition_routines_by_ids
    @nutrition_routines = NutritionRoutine.nutrition_routines_by_ids(set_ids,nutrition_routine_pagination)
    render json: @nutrition_routines,status: :ok
  end

  def nutrition_routines_by_not_ids
    @nutrition_routines = NutritionRoutine.nutrition_routines_by_not_ids(set_ids,nutrition_routine_pagination)
    render json: @nutrition_routines,status: :ok
  end

  def nutrition_routines_by_start_date
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_start_date_and_user_and_trainer_id(params[:date],nutrition_routine_pagination.merge({traienr: params[:trainer_id],user: params[:user_id]}))
    elsif params.has_key?(:user_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_start_date_and_user_id(params[:date],nutrition_routine_pagination.merge(user: params[:user_id]))
    elsif params.has_key?(:trainer_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_start_date_and_trainer_id(params[:date],nutrition_routine_pagination.merge(trainer: params[:trainer_id]))
    else
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_start_date(params[:date],nutrition_routine_pagination)
    end
    render json: @nutrition_routines,status: :ok
  end

  def nutrition_routines_by_end_date
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_end_date_and_user_and_trainer_id(params[:date],nutrition_routine_pagination.merge({traienr: params[:trainer_id],user: params[:user_id]}))
    elsif params.has_key?(:user_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_end_date_and_user_id(params[:date],nutrition_routine_pagination.merge(user: params[:user_id]))
    elsif params.has_key?(:trainer_id)
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_end_date_and_trainer_id(params[:date],nutrition_routine_pagination.merge(trainer: params[:trainer_id]))
    else
      @nutrition_routines = NutritionRoutine.nutrition_routines_by_end_date(params[:date],nutrition_routine_pagination)
    end
    render json: @nutrition_routines,status: :ok
  end

  def nutrition_routine_with_food_day
    @nutrition_routines = NutritionRoutine.nutrition_routine_with_food_day(nutrition_routine_pagination)
    render json: @nutrition_routines,status: :ok
  end

  private
  def set_ids
    if params.has_key?(:nutrition_routine)
      ids = params[:nutrition_routine][:ids].split(",")
    end
    ids ||= []
    ids
  end

  def set_nutrition_routine
    @nutrition_routine = NutritionRoutine.nutrition_routine_by_id(params[:id])
  end

  def nutrition_routine_params
    params.require(:nutrition_routine).permit(:name,:description,:objective,:start_date,:end_date)
  end

  def add_food_days(food_days,resource)
    food_days.each do |id|
      food_day = FoodDay.find_by_id(id)
      resource << food_day
      food_day.save
    end
  end

  def nutrition_routine_pagination
    {page: @page,per_page: @per_page}
  end
end
