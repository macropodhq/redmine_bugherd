require 'redmine'

Redmine::Plugin.register :redmine_bugherd do
  name 'Redmine Bugherd plugin'
  author 'BugHerd Pty Ltd'
  description 'Redmine plugin for BugHerd.com'
  version '1.1.1'
  url 'https://github.com/bugherd/redmine_bugherd'
  author_url 'http://www.bugherd.com'
end

require 'dispatcher'
require 'bugherd_journal_observer'
Dispatcher.to_prepare do
  JournalObserver.instance.extend(BugherdJournalObserver)
end
