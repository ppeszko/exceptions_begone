class ProjectsController < ApplicationController
  
  before_filter :load_project
  
  def index
    @projects = Project.paginate(:per_page => 10, :page => params[:page])
  end
  
  def show
    redirect_to project_stacks_url(@project)
  end
  
  def edit
    render :new
  end
  
  def update
    @project.update_attributes(params[:project])
    if @project.save
      flash[:notice] = "Project succefully updated"
      redirect_to root_url
    else
      render :new
    end
  end
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(params[:project])
    
    if @project.save
      flash[:notice] = "You accidentally the whole project!!!"
      redirect_to root_url
    else
      render :new
    end
  end
  
  def destroy
    @project.destroy
    redirect_to root_url
  end
end
