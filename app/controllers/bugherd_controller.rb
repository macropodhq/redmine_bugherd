class BugherdController < ApplicationController
  unloadable
  accept_api_auth :update, :add_comment, :project_list, :status_list, :priority_list, :trigger_web_hook
  
  def plugin_version
    render :text => "1.1.1"
  end

  def trigger_web_hook
    api_user = find_current_user
    unless api_user and api_user.admin?
      render :text => 'FAIL'
      return
    end

    @project = Project.find(params[:project_id])
    
    field = ProjectCustomField.find_by_name('BugHerd Project Key')
    return unless field

    value = CustomValue.find_by_customized_id_and_custom_field_id(@project.id, field.id)
    return unless value

    project_key = value.value
    return unless project_key.present?

    http = Net::HTTP.new(BugherdJournalObserver::BUGHERD_URL, BugherdJournalObserver::BUGHERD_PORT)
    http.get("/redmine_web_hook/#{project_key}")
    
    render :text => 'OK'
  end

  def project_list
    api_user = find_current_user
    unless api_user and api_user.admin?
      render :text => 'FAIL'
      return
    end
    list = []
    Project.all(:order => 'name').each do |project|
      list << {:id => project.id, :name => project_name(project)} if project.active?
    end
    render :xml => list.to_xml (:root => 'records')
  end

  def status_list
    api_user = find_current_user
    unless api_user and api_user.admin?
      render :text => 'FAIL'
      return
    end
    render :xml => IssueStatus.all
  end

  def priority_list
    api_user = find_current_user
    unless api_user and api_user.admin?
      render :text => 'FAIL'
      return
    end
    render :xml => IssuePriority.all
  end

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
    
    @issue.subject = truncate(params[:description], 80) if params[:description]
    @issue.description = params[:description] if params[:description]
    
    redmine_status = IssueStatus.first(:conditions => ['lower(name) = ?', params[:status].downcase]) if params[:status]
    @issue.status = redmine_status if redmine_status
    
    redmine_priority = IssuePriority.first(:conditions => ['lower(name) = ?', params[:priority].downcase]) if params[:priority]
    @issue.priority = redmine_priority if redmine_priority
    
    @issue.assigned_to = User.find_by_mail(params[:assignee]) if params[:assignee]
    
    if @issue.save
      unless params[:id].present?
        @issue.journals.create(:notes => "See #{params[:url]}", :user => User.current)
      end
      
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
  
private

  def truncate(s, length, options = {})
    text = s.dup
    options[:omission] ||= "..."

    length_with_room_for_omission = length - options[:omission].mb_chars.length
    chars = text.mb_chars
    stop = options[:separator] ?
      (chars.rindex(options[:separator].mb_chars, length_with_room_for_omission) || length_with_room_for_omission) : length_with_room_for_omission

    (chars.length > length ? chars[0...stop] + options[:omission] : text).to_s
  end

  def project_name(project)
    if project.parent
      "#{project_name(project.parent)} > #{project.name}"
    else
      project.name
    end
  end
  
end
