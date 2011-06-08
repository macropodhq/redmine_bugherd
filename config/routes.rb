ActionController::Routing::Routes.draw do |map|
  map.connect 'bugherd/issue/update', :controller => 'bugherd', :action => 'update'
  map.connect 'bugherd/issue/add_comment', :controller => 'bugherd', :action => 'add_comment'
end
