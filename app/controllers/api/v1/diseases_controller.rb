class Api::V1::DiseasesController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin!, only: [:create,:update,:destroy]
  before_action :set_disease, only: [:show,:update,:destroy]
  before_action only: [:index,:diseases_by_search,:diseases_by_ids,:diseases_by_not_ids,:diseases_with_medical_records,:diseases_with_medical_records_by_id,:diseases_by_user] do
    set_pagination(params)
  end

  def index
    @diseases = Disease.load_diseases(disesae_pagination.merge(disease_params:params[:disease_params]))
    render json: @diseases,status: :ok,each_serializer: Api::V1::DiseaseSerializer, render_attribute: params[:disease_params] || "all"
  end

  def show
    if @disease
      if stale?(@disease,public: true)
        render json: @disease,status: :ok, :location => api_v1_disease_path(@disease),serializer: Api::V1::DiseaseSerializer, render_attribute: params[:disease_params] || "all"
      end
    else
      record_not_found
    end
  end

  def create
    @disease = Disease.new(disease_params)
    if @disease.save
      render json: @disease,status: :ok, :location => api_v1_disease_path(@disease), serializer: Api::V1::DiseaseSerializer, render_attribute: params[:disease_params] || "all"
    else
      record_errors(@disease)
    end
  end

  def update
    if @disease
      if @disease.update(disease_params)
        render json: @disease,status: :ok, :location => api_v1_disease_path(@disease), serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
      else
        record_errors(@disease)
      end
    else
      record_not_found
    end
  end

  def destroy
    if @disease
      @disease.destroy
      head :no_content
    else
      record_not_found
    end
  end

  def diseases_by_search
    if params.has_key?(:q)
      @diseases = Disease.diseases_by_search(params[:q],disesae_pagination.merge(disease_params:params[:disease_params]))
      render json: @diseases,status: :ok,each_serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
    else
      q_not_found
    end
  end

  def diseases_by_ids
    @diseases = Disease.diseases_by_ids(set_ids,disesae_pagination.merge(disease_params:params[:disease_params]))
    render json: @diseases,status: :ok, each_serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
  end

  def diseases_by_not_ids
    @diseases = Disease.diseases_by_not_ids(set_ids,disesae_pagination,disease_params:params[:disease_params])
    render json: @diseases,status: :ok,each_serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
  end

  def diseases_with_medical_records
    @diseases = Disease.diseases_with_medical_records(disesae_pagination.merge(disease_params:params[:disease_params]))
    render json: @diseases,status: :ok, each_serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
  end

  def diseases_with_medical_records_by_id
    @diseases = Disease.diseases_with_medical_records_by_id(params[:medical_record_id],disesae_pagination.merge(disease_params:params[:disease_params]))
    render json: @diseases,status: :ok, each_serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
  end

  def diseases_by_user
    @diseases = Disease.diseases_by_user(params[:user_id],disesae_pagination.merge(disease_params:params[:disease_params]))
    render json: @diseases,status: :ok, each_serializer: Api::V1::DiseaseSerializer,render_attribute: params[:disease_params] || "all"
  end

  private
  def set_disease
    @disease = Disease.disease_by_id(params[:id],{disease_params:params[:disease_params]})
  end

  def disease_params
    params.require(:disase).permit(:name,:description)
  end

  def disesae_pagination
    {page: @page,per_page: @per_page}
  end


  def set_ids
    if params.has_key?(:disease)
      ids = params[:disease][:ids].split(",")
    end
    ids ||= []
    ids
  end
end
