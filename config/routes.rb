if Rails::VERSION::MAJOR >= 3

RedmineApp::Application.routes.draw do
  match 'bugherd/plugin_version', :controller => 'bugherd', :action => 'plugin_version'
  match 'bugherd/project_list.:format', :controller => 'bugherd', :action => 'project_list'
  match 'bugherd/status_list.:format', :controller => 'bugherd', :action => 'status_list'
  match 'bugherd/priority_list.:format', :controller => 'bugherd', :action => 'priority_list'
  match 'bugherd/trigger_web_hook/:project_id.:format', :controller => 'bugherd', :action => 'trigger_web_hook'
  match 'bugherd/issue/update.:format', :controller => 'bugherd', :action => 'update'
  match 'bugherd/issue/add_comment.:format', :controller => 'bugherd', :action => 'add_comment'  
end

else

ActionController::Routing::Routes.draw do |map|
  map.connect 'bugherd/plugin_version', :controller => 'bugherd', :action => 'plugin_version'
  map.connect 'bugherd/project_list.:format', :controller => 'bugherd', :action => 'project_list'
  map.connect 'bugherd/status_list.:format', :controller => 'bugherd', :action => 'status_list'
  map.connect 'bugherd/priority_list.:format', :controller => 'bugherd', :action => 'priority_list'
  map.connect 'bugherd/trigger_web_hook/:project_id.:format', :controller => 'bugherd', :action => 'trigger_web_hook'
  map.connect 'bugherd/issue/update.:format', :controller => 'bugherd', :action => 'update'
  map.connect 'bugherd/issue/add_comment.:format', :controller => 'bugherd', :action => 'add_comment'
end

end
