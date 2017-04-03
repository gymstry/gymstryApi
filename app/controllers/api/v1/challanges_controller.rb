class Api::V1::ChallangesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:admin,:trainer]
  before_action :authenticate_member!, only: [:destroy]
  before_action :authenticate_trainer!, only: [:create,:update]
  before_action :set_challenge, only: [:show]
  before_action only: [:index,:challanges_by_ids,:challanges_by_not_ids,:challanges_by_search,:challanges_by_type,:challanges_by_state,:challanges_by_start_date,:challanges_by_end_date] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_user_and_trainer_id(params[:user_id],challenge_pagination.merge({trainer: params[:trainer_id]}).merge(challenge_params: params[:challenge_params]))
    elsif params.has_key?(:user_id)
      @challenges = Challange.challanges_by_user_id(params[:user_id],challenge_pagination.merge(challenge_params: params[:challenge_params]))
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_trainer_id(params[:trainer_id],challenge_pagination.merge(challenge_params: params[:challenge_params]))
    else
      @challenges = Challange.load_challanges(challenge_pagination.merge(challenge_params: params[:challenge_params]))
    end
    render json: @challenges,status: :ok,root: "data",each_serializer: Api::V1::ChallangeSerializer,render_attribute: params[:challenge_params] || "all"
  end

  def show
    if @challenges
      if stale?(@challenge,public: true)
        render json: @challenge,status: :ok, :location => api_v1_challange_path(@challenge),root: "data",serializer: Api::V1::ChallangeSerializer,render_attribute: params[:challenge_params] || "all"
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
      render json: @challenge,status: :ok, :location => api_v1_challange_path(@challenge),root: "data",serializer: Api::V1::ChallangeSerializer,render_attribute: params[:challenge_params] || "all"
    else
      record_errors(@challenge)
    end
  end

  def update
    if @challenge
      if @challenge.trainer_id == current_trainer.id
        if @challenge.update(challenge_params)
          render json: @challenge,status: :ok, :location => api_v1_challange_path(@challange),root: "data", serializer: Api::V1::ChallangeSerializer, render_attribute: params[:challenge_params] || "all"
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
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def challanges_by_ids
    @challenges = Challange.challanges_by_ids(set_ids,challenge_pagination.merge(challenge_params: params[:challenge_params]))
    render json: @challenges,status: :ok, each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
  end

  def challanges_by_not_ids
    @challenges = Challange.challanges_by_not_ids(set_ids,challenge_pagination.merge(challenge_params: params[:challenge_params]))
    render json: @challenges,status: :ok,each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
  end

  def challanges_by_search
    if params.has_key?(:q)
      @challenges = Challange.challanges_by_search(params[:q], challenge_pagination.merge(challenge_params: params[:challenge_params]))
      render json: @challenges, status: :ok,each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
    else
      q_not_found
    end
  end

  def challanges_by_type
    if params.has_key?(:user_id)
      @challenges = Challange.challanges_by_type(params[:type],challenge_pagination.merge(challenge_params: params[:challenge_params]))
        .search_by_user_id(params[:user_id])
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_type(params[:type],challenge_pagination.merge(challenge_params: params[:challenge_params]))
        .search_by_trainer_id(params[:trainer_id])
    else
      @challenges = Challange.challanges_by_type(params[:type],challenge_pagination.merge(challenge_params: params[:challenge_params]))
    end
    render json: @challenges,status: :ok,each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
  end

  def challanges_by_state
    if params.has_key?(:user_id)
      @challenges = Challange.challanges_by_state(params[:state], challenge_pagination.merge(challenge_params: params[:challenge_params]))
        .search_by_user_id(params[:user_id])
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_state(params[:state], challenge_pagination.merge(challenge_params: params[:challenge_params]))
        .search_by_trainer_id(params[:trainer_id])
    else
      @challenges = Challange.challanges_by_state(params[:state], challenge_pagination.merge(challenge_params: params[:challenge_params]))
    end
    render json: @challenges,status: :ok,each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
  end

  def challanges_by_start_date
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_start_date_and_user_and_trainer(params[:type],challenge_pagination.merge({user: params[:user_id],trainer: params[:trainer_id],year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    elsif params.has_key?(:user_id)
      @challenges = Challange.challanges_by_start_date_and_user(params[:type],challenge_pagination.merge({trainer: params[:trainer_id],year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_start_date_and_trainer(params[:type],challenge_pagination.merge({user: params[:user_id],year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    else
      @challenges = Challange.challanges_by_start_date(params[:type],challenge_pagination.merge({year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    end
    render json: @challenges,status: :ok,each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
  end

  def challanges_by_end_date
    if params.has_key?(:user_id) && params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_end_date_and_user_and_trainer(params[:type],challenge_pagination.merge({user: params[:user_id],trainer: params[:trainer_id],year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    elsif params.has_key?(:user_id)
      @challenges = Challange.challanges_by_end_date_and_user(params[:type],challenge_pagination.merge({user: params[:user_id],year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    elsif params.has_key?(:trainer_id)
      @challenges = Challange.challanges_by_end_date_and_trainer(params[:type],challenge_pagination.merge({trainer: params[:trainer_id],year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    else
      @challenges = Challange.challanges_by_end_date(params[:type],challenge_pagination.merge({year: params[:year],month: params[:month]}).merge(challenge_params: params[:challenge_params]))
    end
    render json: @challenges,status: :ok,each_serializer: Api::V1::ChallangeSerializer,root: "data",render_attribute: params[:challenge_params] || "all"
  end

  private
  def set_challenge
    @challenge = Challange.challange_by_id(params[:id], {challange_params: params[:challenge_params] })
  end

  def set_challenge_with_all_attributes
    @challenge = Challange.challenge_by_id(params[:id])
  end

  def challenge_params
    params.require(:challange).permit(:name,:description,:type_challange,:start_date,:end_date,:state,:objective)
  end

  def challenge_pagination
    {page: @page,per_page: @per_page}
  end

  def set_ids
    if params.has_key?(:challenge)
      ids = params[:challenge][:ids].split(",")
    end
    ids ||= []
    ids
  end

end
