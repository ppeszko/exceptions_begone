class NotificationsController < ApplicationController
  
  skip_before_filter :verify_authenticity_token
  
  before_filter :load_project
  
  def create
    attributes = params[:notification]
    @notification = Notification.build(@project, attributes)
    
    if @notification.save
      respond_to do |format|
        format.html do
          flash[:notice] = "You accidentally the whole notification!!!"
          redirect_to project_notifications_url(@project)
        end
        format.xml { head :created }
        format.json { head :created }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { head 400 }
      end
    end
  end
end
