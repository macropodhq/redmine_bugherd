require 'redmine'

Redmine::Plugin.register :redmine_bugherd do
  name 'Redmine Bugherd plugin'
  author 'BugHerd Pty Ltd'
  description 'Redmine plugin for BugHerd.com integration'
  version '0.0.1'
  url 'https://github.com/bugherd/redmine_bugherd'
  author_url 'http://www.bugherd.com'
end

require 'dispatcher'
require 'bugherd_issue_observer'
Dispatcher.to_prepare do
  IssueObserver.instance.extend(BugherdIssueObserver)
end
