class Api::V1::ChallangesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:admin,:gym,:trainer]
  before_action :authenticate_member!, only: [:destroy]
  before_action :authenticate_trainer!, only: [:create,:update]
  before_action :set_challenge, only: [:show,:destroy,:update]
  before_action only: [:index,:challanges_by_ids,:challanges_by_name,:challanges_by_type,:challanges_by_state,:challanges_by_start_date,:challanges_by_end_date,:challanges] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:user_id)
      @challenges = Challange.challanges_by_user_id(params[:user_id],@page,@per_page)
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_trainer_id(params[:trainer_id],@page,@per_page)
    else
      @challanges = Challange.load_challanges(@page,@per_page)
    end
    render json: @challenges,status: :ok
  end

  def show
    if @challenges
      if stale?(@challenge,public: true)
        render json: @challenge,status: :ok, :location => api_v1_challanges(@challenge)
      end
    else
      record_not_found
    end
  end

  def create
    @challenge = Challange.new(challenge_params)
    @challange.trainer_id = current_trainer.id
    @challange.user_id = params[:user_id]
    if @challange.save
      render json: @challenge,status: :ok, :location => api_v1_challanges(@challenge)
    else
      record_errors(@challenge)
    end
  end

  def update
    if @challenge
      if @challenge.trainer_id == current_trainer.id
        if @challenge.update(challenge_params)
          render json: @challenge,status: :ok, :location => api_v1_challanges(@challange)
        else
          record_errors(@challenge)
        end
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def destroy
    if @challenge
      if current_member.is_a?(Admin) || (current_member.is_a?(Trainer) && current_member.id == @challenge.trainer_id)
        @challenge.destroy
        head :no_content
      else
        trainer = current_member.trainers.find_by_id(@challenge.trainer_id)
        if trainer
          @challenge.destroy
          head :no_content
        else
          operation_not_allowed
        end
      end
    else
      record_not_found
    end
  end

  def challanges_by_ids
    @challenges = Challange.challanges_by_ids(set_ids,@page,@per_page)
    render json: @challenges,status: :ok
  end

  def challanges_by_not_ids
    @challenges = Challange.challanges_by_not_ids(set_ids,@page,@per_page)
    render json: @challenges,status: :ok
  end

  def challanges_by_name
    @challenges = Challange.challanges_by_name(params[:name] || "", @page,@per_page)
    render json: @challanges, status: :ok
  end

  def challanges_by_type
    if params.has_key?(:user_id)
      @challenges = Challange.challanges_by_type(params[:type] || "",@page,@per_page)
        .search_by_user_id(params[:user_id])
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_type(params[:type] || "",@page,@per_page)
        .search_by_trainer_id(params[:trainer_id])
    else
      @challenges = Challange.challanges_by_type(params[:type] || "",@page,@per_page)
    end
    render json: @challenges,status: :ok
  end

  def challanges_by_state
    if params.has_key?(:user_id)
      @challenges = Challange.challanges_by_state(params[:state] || "", @page,@per_page)
        .search_by_user_id(params[:user_id])
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_state(params[:state] || "", @page,@per_page)
        .search_by_trainer_id(params[:trainer_id])
    else
      @challenges = Challange.challanges_by_state(params[:state] || "", @page,@per_page)
    end
    render json: @challenges,status: :ok
  end

  def challanges_by_start_date
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_start_date_and_user_and_trainer(params[:type],params[:user_id],params[:trainer_id],@page,@per_page,params[:year],params[:month])
    elsif params.has_ke?(:user_id)
      @challenges = Challange.challanges_by_start_date_and_user(params[:type],params[:user_id],@page,@per_page,params[:year],params[:month])
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_start_date_and_trainer(params[:type],params[:trainer_id],@page,@per_page,params[:year],params[:month])
    else
      @challenges = Challange.challanges_by_start_date(params[:type],@page,@per_page,params[:year],params[:month])
    end
    render json: @challenges,status: :ok
  end

  def challanges_by_end_date
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_end_date_and_user_and_trainer(params[:type],params[:user_id],params[:trainer_id],@page,@per_page,params[:year],params[:month])
    elsif params.has_ke?(:user_id)
      @challenges = Challange.challanges_by_end_date_and_user(params[:type],params[:user_id],@page,@per_page,params[:year],params[:month])
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_end_date_and_trainer(params[:type],params[:trainer_id],@page,@per_page,params[:year],params[:month])
    else
      @challenges = Challange.challanges_by_end_date(params[:type],@page,@per_page,params[:year],params[:month])
    end
    render json: @challenges,status: :ok
  end

  def challanges
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_user_and_trainer_id(params[:user_id],params[:trainer_id],@page,@per_page)
    elsif params.has_key?(:user_id)
      @challenges = Challange.challanges_by_user_id(params[:user_id],@page,@per_page)
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_trainer_id(params[:trainer_id],@page,@per_page)
    end
    render json: @challenges, status: :ok
  end


  private
  def set_challenge
    @challenge = Challange.challange_by_id(params[:id])
  end

  def challenge_params
    params.require(:challange).permit(:name,:description,:type_challange,:start_date,:end_date,:state,:objective)
  end

  def set_ids
    if params.has_key?(:challenge)
      ids = params[:challenge][:ids]
    end
    ids ||= []
    ids
  end

end
