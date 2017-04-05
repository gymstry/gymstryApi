class Api::V1::MeasurementsController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:trainer,:gym,:adim]
  before_action :authenticate_member!, only: [:destroy]
  before_action :authenticate_trainer!, only: [:create,:update]
  before_action :set_measurement, only: [:show,:update,:destroy]
  before_action only: [:index,:measurements_by_ids,:measurements_by_not_ids,:measurements_by_date] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:user_id)
      @measurements = Measurement.measurements_by_user(params[:user_id],measurement_pagination.merge(measurement_params: params[:measurement_params]))
    elsif params.has_key?(:trainer_id)
      @measurements = Measurement.measurements_by_trainer(params[:trainer_id],measurement_pagination.merge(measurement_params: params[:measurement_params]))
    else
      @measurements = Measurement.load_measurements(measurement_pagination.merge(measurement_params: params[:measurement_params]))
    end
    render json: @measurements,status: :ok,each_serializer: Api::V1::MeasurementSerializer,render_attribute: params[:measurement_params] || "all"
  end

  def show
    if @measurement
      if stale?(@measurement,public: true)
        render json: @measurement,status: :ok, :location => api_v1_measurement_path(@measurement), serializer: Api::V1::MeasurementSerializer, render_attribute: params[:measurement_params],render_attribute: params[:measurement_params] || "all"
      end
    else
      record_not_found
    end
  end

  def create
    @measurement = Measurement.new(measurement_params)
    user = User.find_by_id(params[:id])
    if user
      if user.branch_id ==  current_trainer.branch_id
        @measurement.user_id = user.id
        if @measurement.save
          render json: @measurement,status: :created,:location => api_v1_measurement_path(@measurement), serializer: Api::V1::MeasurementSerializer,render_attribute: params[:measurement_params]
        else
          record_errors(@measurement)
        end
      else
        traniner_and_user
      end
    else
      user_not_found
    end
  end

  def update
    if @measurement
      user = User.find_by_id(params[:id])
      if user
        @measurement.trainer_id = measurement.trainer_id ?  @measurement.trainer_id : current_trainer.id
        if @measurement.user_id == user.id && @measurement.trainer_id == current_trainer.id
          if @measurement.update(measurement_params)
            render json: @measurement,status: :ok,:location => api_v1_measurement_path(@measurement),serializer: Api::V1::MeasurementSerializer,render_attribute: params[:measurement_params]
          else
            record_errors(@measurement)
          end
        else
          operation_not_allowed
        end
      else
        user_not_found
      end
    else
      record_not_found
    end
  end

  def destroy
    if @measurement
      if current_member.is_a?(Admin) || (current_member.is_a?(Trainer) && @measurement.trainer_id == current_member.id)
        @measurement.destroy
        head :no_content
      elsif current_member.is_a?(Admin) && @measurement.user.branch.gym.id == current_member.id
        @measurement.destroy
        head :no_content
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def measurements_by_ids
    @measurements = Measurement.measurements_by_ids(set_ids,measurement_pagination.merge(measurement_params: params[:measurement_params]))
    render json: @measurements,status: :ok, each_serializer: Api::V1::MeasurementSerializer,render_attribute: params[:measurement_params] || "all"
  end

  def measurements_by_not_ids
    @measurements = Measurement.measurements_by_not_ids(set_ids,measurement_pagination.merge(measurement_params: params[:measurement_params]))
    render json: @measurements,status: :ok, each_serializer: Api::V1::MeasurementSerializer,render_attribute: params[:measurement_params] || "all"
  end

  def measurements_by_date
    if params.has_key?(:user_id)
      @measurements = Measurement.measurements_by_date_and_user(params[:user_id],measurement_pagination.merge({type:params[:type],year: params[:year],month: params[:month]}).merge(measurement_params: params[:measurement_params]))
    elsif params.has_key?(:trainer_id)
      @measurements = Measurement.measurements_by_data_and_trainer(params[:trainer_id],measurement_pagination.merge({type: params[:type],year: params[:year],month: params[:month]}).merge(measurement_params: params[:measurement_params]))
    else
      @measurements = Measurement.measurements_by_date(params[:type],measurement_pagination.merge({year: params[:year],month: params[:month]}).merge(measurement_params: params[:measurement_params]))
    end
    render json: @measurements,status: :ok,each_serializer: Api::V1::MeasurementSerializer,render_attribute: params[:measurement_params] || "all"
  end

  private
  def set_ids
    if params.has_key?(:measurement)
      ids = params[:measurement][:ids].split(",")
    end
    ids ||= []
    ids
  end
  def set_measurement
    @measurement = Measurement.measurement_by_id(params[:id],{measurement_params: params[:measurement_params]})
  end

  def measurement_params
    params.require(:measurement).permit(:weight,:hips,:chest,:body_fat_percentage,:waist)
  end

  def measurement_pagination
    {page: @page,per_page: @per_page}
  end
end
