class BugherdController < ApplicationController
  unloadable
  accept_key_auth :update, :add_comment

  def update
    api_user = find_current_user
    unless api_user and api_user.admin?
      render :text => 'FAIL'
      return
    end
    
    User.current = User.find_by_mail(params[:email])
    @project = Project.find(params[:project_id])
    if params[:id].present?
      @issue = @project.issues.find(params[:id])
      @issue.init_journal(User.current, nil)
    else
      @issue = Issue.new
      @issue.project = @project
      @issue.tracker = Tracker.find_by_name('Bug')
      @issue.author = User.current
    end
    
    @issue.subject = params[:description] if params[:description]
    
    redmine_status = IssueStatus.first(:conditions => ['lower(name) = ?', params[:status].downcase]) if params[:status]
    @issue.status = redmine_status if redmine_status
    
    redmine_priority = IssuePriority.first(:conditions => ['lower(name) = ?', params[:priority].downcase]) if params[:priority]
    @issue.priority = redmine_priority if redmine_priority
    
    @issue.assigned_to = User.find_by_mail(params[:assignee]) if params[:assignee]
    
    if @issue.save
      render :text => "OK #{@issue.id}"
    else
      render :xml => @issue.errors
    end
  end
  
  def add_comment
    api_user = find_current_user
    unless api_user and api_user.admin?
      render :text => 'FAIL'
      return
    end
    
    User.current = User.find_by_mail(params[:email])
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.journals.create(:notes => params[:comment], :user => User.current)
    render :text => "OK"
  end
  
end
