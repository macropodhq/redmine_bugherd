require 'redmine'

Redmine::Plugin.register :redmine_bugherd do
  name 'Redmine Bugherd plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end

require 'dispatcher'
require 'bugherd_issue_observer'
Dispatcher.to_prepare do
  IssueObserver.instance.extend(BugherdIssueObserver)
end
