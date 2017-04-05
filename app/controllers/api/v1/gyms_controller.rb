class Api::V1::GymsController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin!, only: [:destroy]
  before_action :set_gym, only: [:show,:destroy]
  before_action only: [:index,:gyms_by_search,:gyms_by_ids,:gyms_by_not_ids,:gyms_with_branches,:gyms_with_pictures,:gyms_by_speciality,:gyms_with_offers,:gyms_with_offers_and_date] do
    set_pagination(params)
  end

  def index
    @gyms = Gym.load_gyms(gym_pagination.merge(gym_params: params[:gym_params]))
    render json: @gyms, status: :ok, each_serializer: Api::V1::GymSerializer, render_attribute: params[:gym_params] || "all"
  end

  def show
    if @gym
      if stale?(@gym,public: true)
        render json: @gym,status: :ok,:location => api_v1_gym_path(@gym), serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
      end
    else
      record_not_found
    end
  end

  def destroy
    if @gym
      @gym.destroy
      head :no_content
    else
      record_not_found
    end
  end

  def gyms_by_search
    if params.has_key?(:q)
      @gyms = Gym.gyms_by_search(params[:q], gym_pagination.merge(gym_params: params[:gym_params]))
      render json: @gyms, status: :ok, each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
    else
      q_not_found
    end
  end

  def gyms_by_ids
    ids = set_ids
    @gyms = Gym.gyms_by_ids(ids,gym_pagination.merge(gym_params: params[:gym_params]))
    render json: @gyms, status: :ok,  each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  def gyms_by_not_ids
    ids = set_ids
    @gyms = Gym.gyms_by_not_ids(ids,gym_pagination.merge(gym_params: params[:gym_params]))
    render json: @gyms, status: :ok,  each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  def gyms_with_branches
    @gyms = Gym.gyms_with_branches(gym_pagination.merge(gym_params: params[:gym_params]))
    render json: @gyms,status: :ok, each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  def gyms_with_pictures
    @gyms = Gym.gyms_with_pictures(gym_pagination.merge(gym_params: params[:gym_params]))
    render json: @gyms, status: :ok,  each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  def gyms_by_speciality
    @gyms = Gym.gyms_by_speciality(params[:speciality], gym_pagination.merge(gym_params: params[:gym_params]))
    render json: @gyms,status: :ok,  each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  def gyms_with_offers
    @gyms = Gym.gyms_with_offers(gym_pagination)
    render json: @gyms,status: :ok, each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  def gyms_with_offers_and_date
    @gyms = Gym.gyms_with_offers_and_date(params[:type], gym_pagination.merge({year: params[:year],month: params[:month]}))
    render json: @gyms,status: :ok,  each_serializer: Api::V1::GymSerializer,render_attribute: params[:gym_params] || "all"
  end

  private
    def set_gym
      @gym = Gym.gym_by_id(params[:id], {gym_params: params[:gym_params]})
    end

    def gym_pagination
      {page: @page,per_page: @per_page}
    end

    def set_ids
      if params.has_key?(:gym)
        ids = params[:gym][:ids].split(",")
      end
      ids ||= []
      ids
    end

end
