class Api::V1::BranchesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:gym,:admin]
  before_action :authenticate_member!, only: [:destroy]
  before_action only: [:index,:branches_by_name,:branches_by_ids,:branches_by_not_ids,:branches_with_events_range,:branches_with_users,:branches_with_events,:branches_with_trainers,:branches_with_timetables] do
    set_pagination(params)
  end
  before_action :set_branch, only: [:show,:destroy]

  def index
    @branches = nil
    if params.has_key?(:gym_id)
      @branches = Branch.branches_by_gym_id(params[:gym_id],@page,@per_page)
    else
      @branches = Branch.load_branches(@page,@per_page)
    end
    render json: @branches, status: :ok
  end

  def show
    if @branch
      if stale?(@branch,public: true)
        render json: @branch, status: :ok, :location => api_v1_branch(@branch)
      end
    else
      record_not_found
    end
  end

  def destroy
    if @branch
      if current_member.is_a?(:Admin)
        @branch.destroy
        head :no_content
      elsif @brach.gym.id == current_member.id
        @branch.destroy
        head :no_content
      else
        operation_not_allowed
      end
    else
      record_not_found
    end
  end

  def branch_by_email
    @branch = nil
    if params.has_key?(:gym_id)
      @branch = Branch.branch_by_email_and_gym_id(params[:gym_id],params[:email] || "")
    else
      @branch = Branch.branch_by_email(params[:email] || "")
    end
    if @branch
      if stale?(@branch,public: true)
        render json: @branch,status: :ok
      end
    else
      record_not_found
    end
  end

  def branches_by_name
    @branches = nil
    if params.has_key?(:gym_id)
      @branches =  Branch.branches_by_name_and_gym_id(params[:gym_id],params[:name] || "",@page,@per_page)
    else
      @branches = Branch.branches_by_name(params[:name] || "",@page,@per_page)
    end
    if @branches
      render json: @branches,status: :ok
    else
      record_error
    end
  end

  def branches_by_ids
    ids =  set_ids
    @branches = Branch.branches_by_ids(ids,@page,@per_page)
    render json: @branches,status: :ok
  end

  def branches_by_not_ids
    ids = set_ids
    @branches = Branch.branches_by_not_ids(ids,@page,@per_page)
    render json: @branches,status: :ok
  end

  def branches_with_events
    if params.has_key?(:gym_id)
      @brances = Branch.branches_with_events(@page,@per_page)
        .search_by_gym_id(params[:gym_id])
    else
      @brances = Branch.branches_with_events(@page,@per_page)
    end
    render json: @branches, status: :ok
  end

  def branches_with_trainers
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_trainers(@page,@per_page)
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_trainers(@page,@per_page)
    end
    render json: @branches,status: :ok
  end

  def branches_with_users
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_users(@page,@per_page)
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_users(@page,@per_page)
    end
    render json: @branches,status: :ok
  end

  def branches_with_timetables
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_timetables(@page,@per_page)
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_timetables(@page,@per_page)
    end
    render json: @branches,status: :ok
  end

  def branches_with_events_range
    @branches = nil
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_events_by_range_and_gym(params[:gym_id],params[:type] || "today",@page,@per_page, params[:year] || 2017, params[:month] || 1)
    else
      @branches = Branch.branches_with_events_by_range_and_gym(params[:type] || "today",@page,@per_page, params[:year] || 2017, params[:month] || 1)
    end
    render json: @branches,status: :ok
  end

  private
    def set_branch
      @branch = Branch.branch_by_id(params[:id])
    end

    def set_ids
      ids = nil
      if params.has_key?(:branch)
        ids = params[:branch][:ids]
      end
      ids ||= []
      ids
    end

end
