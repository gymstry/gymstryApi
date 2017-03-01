class Api::V1::GymsController < ApplicationController
  include ControllerUtility
  before_action :authenticate_admin! only: [:destroy]
  before_action :set_gym, only: [:show,:destroy]
  before_action only: [:index,:gyms_by_name,:gyms_by_ids,:gyms_by_not_ids,:gyms_with_branches,:gyms_with_pictures,:gyms_by_speciality] do
    set_pagination(params)
  end

  def index
    render json: load_gyms(@page, @per_page), status: :ok
  end

  def show
    if @gym
      if stale?(@gym,public: true)
        render json: @gym,status: :ok,:location => api_v1_gym(@gym)
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

  def gym_by_email
    @gym = Gym.gym_by_email(params[:email] || "")
    if @gym
      if stale?(@gym,public: true)
        render json: @gym, status: :ok
      end
    else
      record_not_found
    end
  end

  def gyms_by_name
    @gyms = Gym.gyms_by_name(params[:name] || "", @page,@per_page)
    render json: @gyms, status: :ok
  end

  def gyms_by_ids
    ids = set_ids
    @gyms = Gym.gyms_by_ids(ids,@page,@per_page)
    render json: @gyms, status: :ok
  end

  def gyms_by_not_ids
    ids = set_ids
    @gyms = Gym.gyms_by_not_ids(ids,@page,@per_page)
    render json: @gyms, status: :ok
  end

  def gyms_with_branches
    @gyms = Gym.gyms_with_branches(@page,@per_page)
    render json: @gyms,status: :ok
  end

  def gyms_with_pictures
    @gyms = Gym.gyms_with_pictures(@page,@per_page)
    render json: @gyms, status: :ok
  end

  def gyms_by_speciality
    @gyms = Gym.gyms_by_speciality(params[:speciality] || "", @page,@per_page)
    render json: @gyms,status: :ok
  end
  private
    def set_gym
      @gym = Gym.gym_by_id(params[:id])
    end

    def set_ids
      if params.has_key?(:gym)
        ids = params[:gym][:ids]
      end
      ids ||= []
      ids
    end

end
