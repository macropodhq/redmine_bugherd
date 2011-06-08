class BugherdController < ApplicationController
  unloadable
  before_filter :require_admin

  BUGHERD_PRIORITY_MAP = {
    0 => 'Normal',
    1 => 'Urgent',
    2 => 'High',
    3 => 'Normal',
    4 => 'Low',
  }

  BUGHERD_STATUS_MAP = {
    0 => 'New',
    1 => 'New',
    2 => 'New',
    4 => 'Resolved',
    5 => 'Closed',
  }

  def update
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
    @issue.status = best_match_status(params[:status_id].to_i) if params[:status_id]
    @issue.priority = best_match_priority(params[:priority_id].to_i) if params[:priority_id]
    
    if @issue.save
      render :text => "OK #{@issue.id}"
    else
      render :xml => @issue.errors
    end
  end
  
  def add_comment
    User.current = User.find_by_mail(params[:email])
    @project = Project.find(params[:project_id])
    @issue = @project.issues.find(params[:id])
    @issue.journals.create(:notes => params[:comment], :user => User.current)
    render :text => "OK"
  end
  
private

  def best_match_status(status_id)
    IssueStatus.find_by_name(BUGHERD_STATUS_MAP[status_id])
  end

  def best_match_priority(priority_id)
    IssuePriority.find_by_name(BUGHERD_PRIORITY_MAP[priority_id])
  end
  
end
