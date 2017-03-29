class Api::V1::FoodsController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin!, only: [:create,:update,:destroy]
  before_action :set_food, only: [:show,:update,:destroy]
  before_action only: [:index,:foods_by_name,:foods_by_ids,:foods_by_not_ids,:foods_by_proteins_greater_than,:foods_by_carbohydrates_greater_than,:foods_by_fats_greater_than,:foods_with_food_days,:foods_with_food_days_by_food_id] do
    set_pagination(params)
  end

  def index
    if params[:food_day_id]
      @foods = Food.foods_with_food_days_by_food_id(params[:food_day],food_pagination)
    else
      @foods = Food.load_foods(food_pagination)
    end
    render json: @foods,status: :ok
  end

  def show
    if @food
      if stale?(@food,public: true)
        render json: @food,status: :ok
      end
    else
      record_not_found
    end
  end

  def create
    @food = Food.new(food_params)
    if @food.save
      render json: @food,status: :created, :location => api_v1_food(@food)
    else
      record_errors(@food)
    end
  end

  def update
    if @food
      if @food.update(food_params)
        render json: @food,status: :ok, :location => api_v1_food(@food)
      end
    else
      record_not_found
    end
  end

  def destroy
    if @food
      @food.destroy
      head :no_content
    else
      record_not_found
    end
  end

  def foods_by_name
    @foods = Food.foods_by_name(params[:name] || "",food_pagination)
    render json: @foods,status: :ok
  end

  def foods_by_ids
    @foods = Food.foods_by_ids(set_ids,food_pagination)
    render json: @foods,status: :ok
  end

  def foods_by_not_ids
    @foods = Food.foods_by_not_ids(set_ids,food_pagination)
    render json: @foods,status: :ok
  end

  def foods_by_proteins_greater_than
    @foods = Food.foods_by_proteins_greater_than(params[:proteins] || 0, food_pagination)
    render json: @foods,status: :ok
  end

  def foods_by_carbohydrates_greater_than
    @foods = Food.foods_by_carbohydrates_greater_than(params[:carbohydrates] || 0, food_pagination)
    render json: @foods,status: :ok
  end

  def foods_by_fats_greater_than
    @foods = Food.foods_by_fats_greater_than(params[:fats] || 0, food_pagination)
    render json: @foods,status: :ok
  end

  def foods_with_food_days
    @foods = Food.foods_with_food_days(food_pagination)
    render json: @foods,status: :ok
  end

  private
  def set_ids
    if params.has_key?(:food)
      ids = params[:food][:ids].split(",")
    end
    ids ||= []
    ids
  end

  def set_food
    @food = Food.food_by_id(params[:id])
  end

  def food_pagination
    {page: @page,per_page: @per_page}
  end

  def food_params
    params.require(:food).permit(:name,:description,:proteins,:carbohydrates,:fats,:image)
  end

end
