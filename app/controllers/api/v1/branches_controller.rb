class Api::V1::BranchesController < ApplicationController
  include ControllerUtility
  devise_token_auth_group :member, contains: [:gym,:admin]
  before_action :authenticate_member!, only: [:destroy]
  before_action only: [:index,:branches_by_ids,:branches_by_not_ids,:branches_by_search,:branches_with_events_range,:branches_with_users,:branches_with_events,:branches_with_trainers,:branches_with_timetables] do
    set_pagination(params)
  end
  before_action :set_branch, only: [:show,:destroy]

  def index
    @branches = nil
    if params.has_key?(:gym_id)
      @branches = Branch.branches_by_gym_id(params[:gym_id],branch_pagination.merge(branch_params: params[:branch_params]))
    else
      @branches = Branch.load_branches(branch_pagination.merge(branch_params: params[:branch_params]))
    end
    render json: @branches, status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def show
    if @branch
      if stale?(@branch,public: true)
        render json: @branch, status: :ok, :location => api_v1_branch_path(@branch), root: "data", serializer: Api::V1::BranchSerializer,render_attribute: params[:branch_params] || "all"
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

  def branches_by_ids
    ids =  set_ids
    @branches = Branch.branches_by_ids(ids,branch_pagination.merge(branch_params: params[:branch_params]))
    render json: @branches,status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def branches_by_not_ids
    ids = set_ids
    @branches = Branch.branches_by_not_ids(ids,branch_pagination.merge(branch_params: params[:branch_params]))
    render json: @branches,status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def branches_by_search
    if params.has_key?(:q)
      @branches = Branch.branches_by_search(params[:q],branch_pagination.merge(branch_params: params[:branch_params]))
      render json: @branches, status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
    else
      q_not_found
    end
  end

  def branches_with_events
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_events(branch_pagination.merge(branch_params: params[:branch_params]))
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_events(branch_pagination.merge(branch_params: params[:branch_params]))
    end
    render json: @branches, status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def branches_with_trainers
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_trainers(branch_pagination.merge(branch_params: params[:branch_params]))
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_trainers(branch_pagination.merge(branch_params: params[:branch_params]))
    end
    render json: @branches,status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def branches_with_users
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_users(branch_pagination.merge(branch_params: params[:branch_params]))
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_users(branch_pagination.merge(branch_params: params[:branch_params]))
    end
    render json: @branches,status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def branches_with_timetables
    if params.has_key?(:gym_id)
      @branches = Branch.branches_with_timetables(branch_pagination.merge(branch_params: params[:branch_params]))
        .search_by_gym_id(params[:gym_id])
    else
      @branches = Branch.branches_with_timetables(branch_pagination.merge(branch_params: params[:branch_params]))
    end
    render json: @branches,status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  def branches_with_events_range
     if params.has_key?(:gym_id)
       @branches = Branch.branches_with_events_by_range_and_gym(params[:gym_id],{type: params[:type], year: params[:year], month: params[:month]}.merge(branch_pagination).merge(branch_params: params[:branch_params]))
     else
       @branches = Branch.branches_with_events_by_range_and_gym(params[:type],{year: params[:year], month: params[:month]}.merge(branch_pagination).merge(branch_params: params[:branch_params]))
     end
     render json: @branches,status: :ok,each_serializer: Api::V1::BranchSerializer, root: "data",render_attribute: params[:branch_params] || "all"
  end

  private
    def set_branch
      @branch = Branch.branch_by_id(params[:id],{branch_params: params[:branch_params]})
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
