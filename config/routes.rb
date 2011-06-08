ActionController::Routing::Routes.draw do |map|
  map.connect 'bugherd/issue/update.:format', :controller => 'bugherd', :action => 'update'
  map.connect 'bugherd/issue/add_comment.:format', :controller => 'bugherd', :action => 'add_comment'
end
