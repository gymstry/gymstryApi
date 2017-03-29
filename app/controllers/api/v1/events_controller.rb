class Api::V1::EventsController < ApplicationController
  include ControllerUtility
  before_action :set_event, only: [:show,:update,:destroy]
  before_action :event_params, only: [:create,:update]
  before_action :authenticate_branch!, only: [:create,:update]
  devise_token_auth_group :member, contains: [:admin,:branch,:gym]
  before_action :authenticate_member!, only: [:destroy]
  before_action only: [:index,:events_by_name,:events_by_ids,:events_by_not_ids,:events_by_date,:events_by_type_event,:events_by_type_event_and_date] do
    set_pagination(params)
  end

  def index
    if params.has_key?(:branch_id)
      @events = Event.load_events(event_pagination)
    else
      @events = Event.load_events(event_pagination)
        .search_by_branch_id(params[:branch_id])
    end
    render json: @events,status: :ok
  end

  def show
    if @event
      if stale?(@event,public: true)
        render json: @event,status: :ok, :location => api_v1_event(@event)
      end
    else
      record_not_found
    end
  end

  def create
    @event = Event.new(event_params)
    @event.branch_id = current_branch.id
    if @event.save
      render json: @event,status: :ok, :location => api_v1_event(@event)
    else
      record_errors(@event)
    end
  end

  def update
    if @event
      if @event.branch_id == current_branch.id
        if @event.update(event_params)
          render json: @event,status: :ok, :location => api_v1_event(@event)
        else
          record_errors(@event)
        end
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def destroy
    if @event
      if current_member.is_a?(Admin) || (current_member.is_a?(Branch) && current_member.id == @event.branch_id)
        @event.destroy
        head :no_content
      elsif current_member.is_a?(Gym)
        branch = current_member.branches.find_by_id(@event.branch_id)
        if branch
          @event.destroy
          head :no_content
        else
          operation_not_allowed
        end
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def events_by_name
    if params.has_key?(:branch_id)
      @events = Event.events_by_name(params[:name] || "",event_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @events = Event.events_by_name(params[:name] || "",event_pagination)
    end
    render json: @events,status: :ok
  end

  def events_by_ids
    @events = Event.events_by_ids(set_ids,event_pagination)
    render json: @events,status: :ok
  end

  def events_by_not_ids
    @events = Event.events_by_not_ids(set_ids,event_pagination)
    render json: @events,status: :ok
  end

  def events_by_date
    if params.has_key?(:branch_id)
      @events = Event.events_by_date_and_branch(params[:type] || 'today',event_pagination.merge({trainer: params[:trainer_id],year: params[:year],month:params[:month]}))
    else
      @events = Event.events_by_date(params[:type] || 'today',event_pagination.merge({year: params[:year],month: params[:month]}))
    end
    render json: @events,status: :ok
  end

  def events_by_type_event
    if params.has_key?(:branch_id)
      @events = Event.events_by_type_event(params[:type_event] || "other",event_pagination)
        .search_by_branch_id(params[:branch_id])
    else
      @events = Event.events_by_type_event(params[:type_event] || "other", event_pagination)
    end
    render json: @events,status: :ok
  end

  def events_by_type_event_and_date
    if params.has_key?(:branch_id)
      @events = Event.events_by_type_event_date(params[:type_event] || "other", event_pagination.merge({type: params[:type] || "today" ,year: params[:year],month: params[:month]}))
        .search_by_branch_id(params[:branch_id])
    else
      @events = Event.events_by_type_event_date(params[:type_event] || "other",event_pagination.merge({type: params[:type] || "today" ,year: params[:year],month: params[:month]}))
    end
    render json: @events,status: :ok
  end


  protected
  def set_event
    @event = Event.event_by_id(params[:id])
  end

  def event_pagination
    {page: @page,per_page: @per_page}
  end

  def event_params
    params.require(:event).permit(:name,:description,:otro_name,:class_date,:duration,:type_event,:image)
  end

  def set_ids
    if params.has_key?(:event)
      ids = params[:event][:ids].split(",")
    end
    ids ||= []
    ids
  end

end
