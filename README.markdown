BugHerd for Redmine
===================

Introduction
------------

### What's this?

BugHerd is the world's simplest bug tracker for websites. Because it's totally cool and plays well with other cool applications, it integrates with Redmine but requires this plugin to be installed.

If you have been asked to install this by your colleague, you may not have seen BugHerd yet and might want to check it out: http://www.bugherd.com

### What does it do?

This plugin enables new APIs for use by BugHerd's server to update issues, and has the ability to call BugHerd back when an issue changes.

### Is it secure?

Yes, all APIs defined by this plug-in that enable information to be passed in and out require that an administrator's API key is used to access them.

Compatibility
-------------

Redmine 1.2 and 1.3

Support
-------

When experiencing issues or if you require assistance with setup please open a ticket on http://support.bugherd.com

Installation
------------

### Custom install

To (re)install the BugHerd Redmine plugin, go to the base directory of your Redmine instance on your server:

    script/plugin install git://github.com/bugherd/redmine_bugherd.git --force
  
Reload your Redmine instance. If you use Passenger:

    touch tmp/restart.txt

Installation can be verified by visiting:

    http://<server>/bugherd/plugin_version

This should display the version of this plugin.

### BitNami Redmine Virtual Machine

Find the VM appliance here: http://bitnami.org/stack/redmine

Log into VMware console

    cd /opt/bitnami
    ./use_redmine
    cd apps/redmine/vendor/plugins
    sudo git clone git://github.com/bugherd/redmine_bugherd.git
    exit
    sudo /etc/init.d/bitnami restart

Verify the installation:

    http://<server>/redmine/admin/plugins
    http://<server>/redmine/bugherd/plugin_version

The last URL should display the version of this plugin.


Setup
-----

Enable APIs:

1. Go to: Administration > Settings
2. Open the "Authentication" tab
3. Tick "Enable REST web service"
4. Click Save

Create a Project Custom Field called "BugHerd Project Key":

1. Go to Administration > Custom Fields
2. Open the "Projects" tab
3. Select "New custom field"
4. Complete these fields:
   - Name: **BugHerd Project Key**
   - Format: (leave at "Text")
   - Min - Max length: (leave at: "0" - "0")
   - Regular expresssion: (leave blank)
   - Default value: (leave blank)
   - Required: (leave unticked)
   - Visible: **untick** (to ensure the value is not seen by anyone but the project managers)
   - Searchable: (leave unticked)
5. Click Save

Your Redmine instance is now ready to be integrated with BugHerd.

More info
---------

Plugin description: http://www.redmine.org/plugins/redmine_bugherd

Setup guide: http://support.bugherd.com/entries/20425381-github

About BugHerd: http://www.bugherd.com/about

Change notes
------------

1.1.1 (21 Oct 2011)
Bypass validations of custom mandatory fields when creating/updating issues

1.1.0 (6 Sep 2011)
BugHerd description now mapped to Redmine description instead of subject
Subject will have a truncated description where length over 80 characters
New issues created in Redmine will now include a URL to the BugHerd issue as comment

1.0.2 (4 Aug 2011)
Webhook bugfix and project list order

1.0.1 (4 Aug 2011)
Essential bugfixes
