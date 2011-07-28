module BugherdJournalObserver
  BUGHERD_URL = 'www.bugherd.com'
  BUGHERD_PORT = 80
  
  def after_save(journal)
    super(journal)
    
    issue = journal.journalized.reload
        
    field = ProjectCustomField.find_by_name('BugHerd Project Key')
    return unless field

    value = CustomValue.find_by_customized_id_and_custom_field_id(issue.project.id, field.id)
    return unless value

    project_key = value.value
    return unless project_key.present?

    issue_xml = journal.to_xml(
      :include => {:issue => {
        :only => [:id, :subject, :description],
        :include => {
          :status => {:only => [:id, :name]},
          :priority => {:only => [:id, :name]},
          :tracker => {:only => [:id, :name]},
          :project => {:only => [:id, :name]},
          :author => {:only => [:id, :firstname, :lastname, :login, :mail]},
          :assigned_to => {:only => [:id, :firstname, :lastname, :login, :mail]},
        }
      }}
    )

    http = Net::HTTP.new(BUGHERD_URL, BUGHERD_PORT)
    resp = http.post("/redmine_web_hook/#{project_key}", issue_xml, {'Content-Type' => 'application/xml'})
  end
end
