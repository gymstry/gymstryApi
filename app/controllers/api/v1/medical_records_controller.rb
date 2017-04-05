class Api::V1::MedicalRecordsController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member,contains: [:admin,:gym]
  before_action :authenticate_gym!, only: [:create,:update]
  before_action :authenticate_member!, only: [:destroy]
  before_action :set_medical_record, only: [:show,:update,:destroy]
  before_action only: [:index,:medical_records_by_ids,:medical_records_by_not_ids,:medical_records_with_diseases,:medical_records_with_exercises] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:user_id)
      @medical_record = MedicalRecord.medical_record_by_user(params[:user_id],medical_record_pagination.merge(medical_record_params: params[:medical_record_params]))
    else
      @medical_records = MedicalRecord.load_medical_records(medical_record_pagination.merge(medical_record_params: params[:medical_record_params]))
    end
    render json: @medical_records,status: :ok,each_serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record_params] || "all"
  end

  def show
    if @medical_record
      if stale?(@medical_record,public: true)
        render json: @medical_record,status: :ok, :location => api_v1_medical_record_path(@medical_record),serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record_params] || "all"
      end
    else
      record_not_found
    end
  end

  def create
    @medical_record = MedicalRecord.new(medical_record_params)
    user = User.user_by_id(params[:user_id])
    if user.branch.gym.id == current_gym
      @medical_record.user_id = user.id
      if @medical_record.save
        render json: @medical_record,status: :created,:location => api_v1_medical_record_path(@medical_record),serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record] || "all"
      else
        record_errors(@medical_record)
      end

    else
      user_and_gym
    end
  end

  def update
    if @medical_record
      if @medical_record.user.branch.gym.id == current_gym.id
        if @medical_record.update(medical_record_params)
          render json: @medical_record,status: :ok,:location => api_v1_medical_record_path(@medical_record),serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record] || "all"
        else
          record_errors(@medical_record)
        end
      else
        user_and_gym
      end
    else
      record_not_found
    end
  end

  def destroy
    if @medical_record
      if current_member.is_a?(Admin) || (@medical_record.user.branch.gym.id == current_member.id)
        @medical_record.destroy
        head :no_content
      else
        user_and_gym
      end
    else
      record_not_found
    end
  end

  def medical_records_by_ids
    @medical_records = MedicalRecord.medical_records_by_ids(set_ids,medical_record_pagination.merge(medical_record_params: params[:medical_record_params]))
    render json: @medical_records,status: :ok,each_serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record_params] || "all"
  end

  def medical_records_by_not_ids
    @medical_records = MedicalRecord.medical_records_by_not_ids(set_ids,medical_record_pagination.merge(medical_record_params: params[:medical_record_params]))
    render json: @medical_records,status: :ok,each_serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record_params] || "all"
  end

  def medical_records_with_diseases
    @medical_records = MedicalRecord.medical_records_with_diseases(medical_record_pagination.merge(medical_record_params: params[:medical_record_params]))
    render json: @medical_records,status: :ok,each_serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record_params] || "all"
  end

  def medical_records_with_exercises
    @medical_records = MedicalRecord.medical_records_with_exercises(medical_record_pagination)
    render json: @medical_records,status: :ok,each_serializer: Api::V1::MedicalRecordSerializer,render_attribute: params[:medical_record_params] || "all"
  end

  private
  def set_ids
    if params.has_key?(:medical_record)
      ids = params[:medical_record][:ids].split(",")
    end
    ids ||= []
    ids
  end

  def medical_record_params
    params.require(:medical_record).permit(:observation,:weight,:medication,:body_fat_percentage,:waist,:hips,:chest)
  end

  def medical_record_pagination
    {page: @page,per_page: @per_page}
  end

  def set_medical_record
    @medical_record = MedicalRecord.medical_record_by_id(params[:id],{medical_record_params: params[:medical_record_params]})
  end
end
