ActionController::Routing::Routes.draw do |map|
  map.connect 'bugherd/plugin_version', :controller => 'bugherd', :action => 'plugin_version'
  map.connect 'bugherd/project_list.:format', :controller => 'bugherd', :action => 'project_list'
  map.connect 'bugherd/status_list.:format', :controller => 'bugherd', :action => 'status_list'
  map.connect 'bugherd/priority_list.:format', :controller => 'bugherd', :action => 'priority_list'
  map.connect 'bugherd/trigger_web_hook/:project_id.:format', :controller => 'bugherd', :action => 'trigger_web_hook'
  map.connect 'bugherd/issue/update.:format', :controller => 'bugherd', :action => 'update'
  map.connect 'bugherd/issue/add_comment.:format', :controller => 'bugherd', :action => 'add_comment'
end
