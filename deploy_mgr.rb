require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'chef'
require 'yaml'

set :haml, :format => :html5

configure do |c|
  chef_cfg = YAML::load_file("chef.yaml")
  c.set(:data_bag, chef_cfg['data_bag'])
  c.set(:chef, Chef::REST.new(chef_cfg['url'],
                              chef_cfg['client_name'],
                              chef_cfg['key_file']))
end

get '/' do
  @items = settings.chef.get_rest("/data/#{settings.data_bag}")
  haml :item_list
end

get '/environments/:env_name/' do |env_name|
  @env_name = env_name
  item = settings.chef.get_rest("/data/#{settings.data_bag}/#{env_name}")
  item.delete('id')
  @targets = item
  haml :environment
end

post '/environments/:id/update' do
  settings.chef.put_rest("/data/#{settings.data_bag}/#{params[:id]}", params)
  redirect back
end  
