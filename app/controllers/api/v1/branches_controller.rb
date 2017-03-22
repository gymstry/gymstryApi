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
      @branches = Branch.branches_by_gym_id(params[:gym_id],branch_pagination)
    else
      @branches = Branch.load_branches(branch_pagination)
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
      @branches =  Branch.branches_by_name_and_gym_id(params[:gym_id],branch_pagination.merge({name: params[:name] || ""}))
    else
      @branches = Branch.branches_by_name(params[:name] || "",set_pagination)
    end
    if @branches
      render json: @branches,status: :ok
    else
      record_error
    end
  end

  def branches_by_ids
    ids =  set_ids
    @branches = Branch.branches_by_ids(ids,branch_pagination)
    render json: @branches,status: :ok
  end

  def branches_by_not_ids
    ids = set_ids
    @branches = Branch.branches_by_not_ids(ids,branch_pagination)
    render json: @branches,status: :ok
  end

  def branches_with_events
    if params.has_key?(:gym_id)
      @brances = Branch.branches_with_events(branch_pagination)
        .search_by_gym_id(params[:gym_id])
    else
      @brances = Branch.branches_with_events(branch_pagination)
    end
    render json: @branches, status: :ok
  end

  def branches_with_trainers
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_trainers(branch_pagination)
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_trainers(branch_pagination)
    end
    render json: @branches,status: :ok
  end

  def branches_with_users
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_users(branch_pagination)
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_users(branch_pagination)
    end
    render json: @branches,status: :ok
  end

  def branches_with_timetables
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_timetables(branch_pagination)
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_timetables(branch_pagination)
    end
    render json: @branches,status: :ok
  end

  def branches_with_events_range
    @branches = nil
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_events_by_range_and_gym(params[:gym_id],{type: params[:type] || "today", year: params[:year] || 2017, month: params[:month] || 1}.merge(branch_pagination))
    else
      @branches = Branch.branches_with_events_by_range_and_gym(params[:type] || "today",{year: params[:year] || 2017, month: params[:month] || 1}.merge(branch_pagination))
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
        ids = params[:branch][:ids].split(",")
      end
      ids ||= []
      ids
    end

    def branch_pagination
      {page: @page,per_page: @per_page}
    end

end
