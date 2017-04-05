class Api::V1::TrainersController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:branch,:admin]
  before_action :authenticate_member!, only: [:destroy]
  before_action :set_trainer, only: [:show,:destory]
  before_action only: [:index,:trainers_by_ids,:trainers_by_not_ids,:trainers_by_search,:trainers_by_birthday,:trainers_by_speciality,:trainers_with_qualifications,:trainers_with_challanges,:trainers_with_measurements,:trainers_with_nutrition_routines,:trainers_with_workouts] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:branch_id)
      @branches = Trainer.load_trainers(trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @branches = Trainer.load_trainers(trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @branches,status: :ok,  each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def show
    if @trainer
      if stale?(@trainer,public: true)
        render json: @trainer,status: :ok,:location => api_v1_trainer_path(@trainer), serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
      end
    else
      record_not_found
    end
  end

  def destroy
    if @trainer
      if current_member.is_a?(Admin)
        @trainer.destroy
        head :no_content
      elsif current_member.id == @trainer.branch.id
        @user.destroy
        head :no_content
      else
        destroy_not_allowed
      end
    else
      record_not_found
    end
  end

  def trainers_by_ids
    ids = set_ids
    @trainers = Trainer.trainers_by_ids(ids,trainer_pagination.merge(trainer_params: params[:trainer_params]))
    render json: @trainers,status: :ok,  each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_by_not_ids
    ids = set_ids
    @trainers = Trainer.trainers_by_not_ids(ids,trainer_pagination.merge(trainer_params: params[:trainer_params]))
    render json: @trainers,status: :ok,  each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_by_search
    if params.has_key?(:q)
      @trainers = Trainer.trainers_by_search(params[:q],trainer_pagination.merge(trainer_params: params[:trainer_params]))
      render json: @trainers, status: :ok, each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
    else
      q_not_found
    end
  end

  def trainers_by_birthday
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_birthday(params[:type],trainer_pagination.merge({year: params[:year],month: params[:month]}).merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_birthday(params[:type],trainer_pagination.merge({year: params[:year],month: params[:month]}).merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers, status: :ok, each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_by_speciality
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_speciality(params[:speciality],trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_speciality(params[:speciality],trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers,status: :ok, each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_with_qualifications
    if params.has_key?(params[:branch_id])
      @trainers = Trainer.trainers_with_qualifications(trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_qualifications(trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers,status: :ok,  each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_with_challanges
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_challanges(trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_challanges(trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers,status: :ok, each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_with_measurements
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_measurements(trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_measurements(trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers, status: :ok,each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_with_nutrition_routines
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_nutrition_routines(trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_nutrition_routines(trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers,status: :ok, each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  def trainers_with_workouts
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_workouts(trainer_pagination.merge(trainer_params: params[:trainer_params]))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_workouts(trainer_pagination.merge(trainer_params: params[:trainer_params]))
    end
    render json: @trainers, status: :ok,  each_serializer: Api::V1::TrainerSerializer,render_attribute: params[:trainer_params] || "all"
  end

  private

  def set_trainer
    @trainer = Trainer.trainer_by_id(params[:id],{trainer_params: params[:trainer_params]})
  end

  def trainer_pagination
    {page:@page,per_page: @per_page}
  end

  def set_ids
    ids = nil
    if params.has_key?(:trainer)
      ids = params[:trainer][:ids].split(",")
    end
    ids ||= []
    ids
  end

end
