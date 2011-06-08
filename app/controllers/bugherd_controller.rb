class BugherdController < ApplicationController
  unloadable
  before_filter :require_admin

  def update
    project = Project.find(params[:project_id])
    if project
      issue = project.issues.find(params[:id])
      if issue
        render :text => issue.subject
        return
      end
    end
    render :text => 'FAIL'
  end
  
end
