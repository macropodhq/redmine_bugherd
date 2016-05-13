require 'redmine'
require 'bugherd_journal_observer'

Redmine::Plugin.register :redmine_bugherd do
  name 'Redmine Bugherd plugin'
  author 'Macropod Software Pty Ltd'
  description 'Redmine plugin for BugHerd.com'
  version '3.0.0'
  url 'https://github.com/bugherd/redmine_bugherd'
  author_url 'http://www.bugherd.com'

  default_settings = {
    'bugherd_tracker' => 'Bug'
  }

  settings(:default => default_settings, :partial => 'settings/bugherd_settings')
end

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  Dispatcher.to_prepare do
    JournalObserver.instance.extend(BugherdJournalObserver)
  end
end
