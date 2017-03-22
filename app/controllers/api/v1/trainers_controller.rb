class Api::V1::TrainersController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:branch,:admin]
  before_action :authenticate_member!, only: [:destroy]
  before_action :set_trainer, only: [:show,:destory]
  before_action only: [:index,:trainers_by_ids,:trainers_by_not_ids,:trainers_by_name,:trainers_by_lastname,:trainers_by_username_or_email,:trainers_by_birthday,:trainers_by_speciality,:trainers_with_qualifications,:trainers_with_challanges,:trainers_with_measurements,:trainers_with_nutrition_routines,:trainers_with_workouts] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:branch_id)
      @branches = Branch.load_trainers(trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @branches = Branch.load_trainers(trainer_pagination)
    end
    render json: @branches,status: :ok
  end

  def show
    if @trainer
      if stale?(@trainer,public: true)
        render json: @user,status: :ok,:location => api_v1_trainer(@trainer)
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
    @trainers = Trainer.trainers_by_ids(ids,trainer_pagination)
    render json: @trainers,status: :ok
  end

  def trainers_by_not_ids
    ids = set_ids
    @trainers = Trainer.trainers_by_not_ids(ids,trainer_pagination)
    render json: @trainers,status: :ok
  end

  def trainer_by_username
    @trainer = Trainer.trainer_by_username(params[:username] || "")
    if @trainer
      if stale?(@trainer,public: true)
        render json: @trainer,status: :ok
      end
    else
      record_not_found
    end
  end

  def trainer_by_email
    @trainer = Trainer.trainer_by_email(params[:email] || "")
    if @trainer
      if stale?(@trainer,public: true)
        render json: @trainer,status: :ok
      end
    else
      record_not_found
    end
  end

  def trainers_by_name
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_name(params[:name] || "",trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_name(params[:name] || "",trainer_pagination)
    end
    render json: @trainers, status: :ok
  end

  def trainers_by_lastname
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_lastname(params[:lastname] || "",trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_lastname(params[:lastname] || "",trainer_pagination)
    end
    render json: @trainers,status: :ok
  end

  def trainers_by_username_or_email
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_username_or_email(params[:q] || "",trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_username_or_email(params[:q] || "", trainer_pagination)
    end
    render json: @trainers, status: :ok
  end

  def trainers_by_birthday
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_birthday(params[:type],trainer_pagination.merge({year: params[:year],month: params[:month]}))
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_birthday(params[:type],trainer_pagination.merge({year: params[:year],month: params[:month]}))
    end
    render json: @trainers, status: :ok
  end

  def trainers_by_speciality
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_by_speciality(params[:speciality],trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_by_speciality(params[:speciality],trainer_pagination)
    end
    render json: @trainers,status: :ok
  end

  def trainers_with_qualifications
    if params.has_key?(params[:branch_id])
      @trainers = Trainer.trainers_with_qualifications(trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_qualifications(trainer_pagination)
    end
    render json: @trainers,status: :ok
  end

  def trainers_with_challanges
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_challanges(trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_challanges(trainer_pagination)
    end
    render json: @trainers,status: :ok
  end

  def trainers_with_measurements
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_measurements(trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_measurements(trainer_pagination)
    end
    render json: @trainers, status: :ok
  end

  def trainers_with_nutrition_routines
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_nutrition_routines(trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_nutrition_routines(trainer_pagination)
    end
    render json: @trainers,status: :ok
  end

  def trainers_with_workouts
    if params.has_key?(:branch_id)
      @trainers = Trainer.trainers_with_workouts(trainer_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @trainers = Trainer.trainers_with_workouts(trainer_pagination)
    end
    render json: @trainers, status: :ok
  end

  private

  def set_trainer
    @trainer = Trainer.trainer_by_id(params[:id])
  end

  def trainer_pagination
    {page:@page,per_page: @per_page}
  end

  def set_ids
    ids = nil
    if params.has_key?(:trainer)
      ids = params[:trainer][:ids]
    end
    ids ||= []
    ids
  end

end
