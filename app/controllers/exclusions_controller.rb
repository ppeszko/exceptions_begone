class ExclusionsController < ApplicationController
  
  before_filter :load_project
  
  def index
    @exclusions = @project.exclusions
  end
  
  def create
    @exclusion = @project.exclusions.build(params[:exclusion])
    if @exclusion.save
      redirect_to project_exclusions_url(@project)
    else 
      render :new
    end
  end
  
  def edit
    @exclusion = @project.exclusions.find_by_id(params[:id])
    render :new
  end
  
  def update
    @exclusion = @project.exclusions.find_by_id(params[:id])
    if @exclusion
      @exclusion.update_attributes(params[:exclusion])
      redirect_to project_exclusions_url(@project)
    else
      redirect_to project_exclusions_url(@project)
    end
  end
  
  def destroy
    @exclusion = @project.exclusions.find_by_id(params[:id])
    @exclusion.destroy if @exclusion
    redirect_to project_exclusions_url(@project)
  end
  
end
