Overview
========

This is a simple Sinatra application which controls a Chef data bag specifying deployment target revisions, with one item per environment. This allows non-Chef users to control which revisions are deployed.

Configuration
=============

Create a Chef client with `knife client create deploy_mgr` (obviously you can name the client whatever you want). Save the generated private key somewhere appropriate. If you are using Chef Server, this client apparently needs admin rights in order to update data bags.

Create a chef.yaml file containing the following keys:

* `url`: URL of your Chef server, e.g. http://chef.example.com:4000/
* `client_name`: the Chef client name used above
* `key_file`: the location of the private key generated above
* `data_bag`: the name of the Chef data bag storing deployment information.

Ensure the appropriate gems are installed with `bundle install --deployment`.

Run `sinatra deploy_mgr.rb` to start the application.

Chef support
============

To actually make use of this, Chef recipes will need to incorporate something like the following:

    env_deploy = data_bag_item('deploy', node.chef_environment)
    target_rev = env_deploy['my_app']

TODO
====
* add support for branch / tag completion and/or validation
* display per-environment policy information
* add some form of access control
* track and display deployment progress with Chef
