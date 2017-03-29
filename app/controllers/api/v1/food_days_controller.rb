class Api::V1::FoodDaysController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:trainer,:admin]
  before_action :authenticate_trainer!, only: [:create,:update]
  before_action :authenticate_member!, only: [:destroy]
  before_action only: [:index,:food_days_by_ids,:food_days_by_not_ids,:food_days_with_foods,:food_days_by_type] do
    set_pagination(params)
  end
  before_action :set_food_day, only: [:show,:update,:destroy]

  def index
    if params.has_key?(:nutrition_routine)
      @food_days = FoodDay.food_days_by_nutrition_routine(params[:nutrition_routine],args)
    else
      @food_days = FoodDay.load_food_days(food_day_pagination)
    end
    render json: @food_days,status: :ok
  end

  def show
    if @food_day
      if stale?(@food_day,public: true)
        render json: @food_day,status: :ok, :location => api_v1_food_day(@food_day)
      end
    else
      record_not_found
    end
  end

  def create
    @food_day = FoodDay.new(food_day_params)
    nutrition_routine = NutritionRoutine(params[:nutrition_routine])
    if nutrition_routine
      if nutrition_routine.trainer_id == current_trainer.id
        @food_day.nutrition_routine_id = nutrition_routine.id
        if params.has_key?(:foods)
          params[:foods].each do |id|
            food = Food.food_by_id(id)
            @food_day.foods << food
          end
          if @food_day.save
            render json: @food_day,status: :created, :location => api_v1_food_day(@food_day)
          else
            record_errors(@food_day)
          end
        else
          foods_needed
        end
      else
        operation_not_allowed
      end
    else
      nutrition_routine_not_found
    end
  end

  def update
    if @food_day
      if @food_day.nutrition_routine.trainer_id == current_trainer.id
        if @food_day.update(food_day_params)
          render json: @food_day, status: :ok, :location => api_v1_food_day(@food_day)
        else
          record_errors(@food_day)
        end
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def destroy
    if @food_day
      if current_member.is_a?(Admin) || @food_day.nutrition_routine.trainer_id == current_member.id
        @food_day.destroy
        head :no_content
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def food_days_by_ids
    @food_days = FoodDay.food_days_by_ids(set_ids,food_day_pagination)
    render json: @food_days,status: :ok
  end

  def food_days_by_not_ids
    @food_days = FoodDay.food_days_by_not_ids(set_ids,food_day_pagination)
    render json: @food_days,status: :ok
  end

  def food_days_with_foods
    @food_days = FoodDay.food_days_with_foods(food_day_pagination)
    render json: @food_days,status: :ok
  end

  def food_days_by_type
    if params.has_key?(:nutrition_routine)
      @food_days = FoodDay.food_days_by_type(params[:type],food_day_pagination)
        .search_by_nutrition_routine_id(params[:nutrition_routine])
    else
      @food_days = FoodDay.food_days_by_type(params[:type],food_day_pagination)
    end
    render json: @food_days, status: :ok
  end

  private
  def set_food_day
    @food_day = FoodDay.fodd_day_by_id(params[:id])
  end

  def food_day_params
    params.require(:food_day).permit(:type_food,:description,:benefits)
  end

  def food_day_pagination
    {page: @page,per_page: @per_page}
  end

  def set_ids
    if params.has_key?(:food_day)
      ids = params[:food_day][:ids].split(",")
    end
    ids ||= []
    ids
  end
end
