class Api::V1::GymsController < ApplicationController
  include ControllerUtility
  before_action :set_gym, only: [:show]
  before_action only: [:index,:gyms_by_name,:gyms_by_ids,:gyms_by_not_ids,:gyms_with_branches,:gyms_with_pictures] do
    set_pagination(params)
  end

  def index
    render json: load_gyms(@page, @per_page), status: :ok
  end

  def show
    if @gym
      if stale?(@gym,public: true)
        render json: @gym,status: :ok
      end
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
    if @gyms
      render json: @gyms, status: :ok
    else
      record_error
    end
  end

  def gyms_by_ids
    ids = set_ids
    @gyms = Gym.gyms_by_ids(ids,@page,@per_page)
    if @gyms
      render json: @gyms, status: :ok
    else
      record_error
    end
  end

  def gyms_by_not_ids
    ids = set_ids
    @gyms = Gym.gyms_by_not_ids(ids,@page,@per_page)
    if @gyms
      render json: @gyms, status: :ok
    else
      record_error
    end
  end

  def gyms_with_branches
    @gyms = Gym.gyms_with_branches(@page,@per_page)
    if @gyms
      render json: @gyms,status: :ok
    else
      record_error
    end
  end

  def gymms_with_pictures
    @gyns = Gym.gyms_with_pictures(@page,@per_page)
    if @gyms
      render json: @gyms, status: :ok
    else
      record_error
    end
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
