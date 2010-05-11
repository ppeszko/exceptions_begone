class StacksController < ApplicationController
  
  before_filter :load_project
  
  @@order_possiblities = {"category" => "category", "identifier" => "identifier", 
    "count" => "notifications_count DESC", "status" => "status", 
    "updated_at" => "updated_at DESC", "created_at" => "created_at DESC"}
  
  def index
    per_page = (params[:per_page] && params[:per_page]) || 50
    order = @@order_possiblities.fetch(params[:order], "updated_at DESC")
    session[:filter] = params[:filter] ? params[:filter] : session[:filter]
    matching_mode = params[:filter] == "include" ? :include : :exclude
    
    @pager = Paginator.new(@project.stacks.count, per_page) do |offset, per_page|
      @project.find_stacks(params[:search], session[:filter], :offset => offset, :limit => per_page, :order => order)
    end
    @stacks = @pager.page(params[:page])
  end
  
  def show
    stack = Stack.find(params[:id])
    
    @pager = Paginator.new(stack.notifications_count, 1) do |offset, per_page|
      stack.notifications.all(:offset => offset, :limit => per_page, :order => "id ASC")
    end
    
    @notifications = @pager.page(params[:page])
    @notification = @notifications.first
    
    @sections = ActiveSupport::JSON.decode(@notification.payload)
    @backtrace = @sections.delete("backtrace")
    @backtrace = @backtrace.join("<br/>") if @backtrace.present?
  end
  
  def update
    @stack = @project.stacks.find(params[:id])
    @stack.update_attributes(params[:stack])
    if @stack.save
      flash[:notice] = "Notification succefully updated"
      respond_to do |format|
        format.js
        format.html { redirect_to project_stacks_url(@project) }
      end
    else
      redirect_to project_stacks_url(@project)
    end
  end
  
  def destroy
    @stack = Stack.find(params[:id])
    Stack.destroy_all(:identifier => @stack.identifier)
    redirect_to project_stacks_url(@project)
  end
end
