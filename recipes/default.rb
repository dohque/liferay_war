#
# Cookbook Name:: liferay_war
# Recipe:: default
#
# Copyright 2013, PilinSolutions
#

service "tomcat7" do
    supports :status => true, :restart => true
    action :nothing
end

package "unzip" do
    action :install
end

['activation.jar',  'hsql.jar', 'jta.jar', 'jutf7.jar', 'mysql.jar', 'portal-service.jar', 'postgresql.jar',
'ccpp.jar', 'jms.jar', 'jtds.jar', 'mail.jar', 'persistence.jar', 'portlet.jar', 'support-tomcat.jar'].each do |lib|

    cookbook_file "#{node.tomcat.base}/common/#{lib}" do
        source lib
        owner node.tomcat.user
        group node.tomcat.group
        action :create_if_missing
        notifies :restart, "service[tomcat7]", :delayed
    end
end

directory node.liferay.home do
   owner node.tomcat.user
   group node.tomcat.group
end

directory "#{node.tomcat.webapp_dir}/ROOT" do
    action :delete
    recursive true
    not_if { File.exists?("#{node.tomcat.webapp_dir}/ROOT.war") }
end

remote_file "#{node.tomcat.webapp_dir}/ROOT.war" do
    source node.liferay.war
    owner node.tomcat.user
    group node.tomcat.group
    action :create_if_missing
    notifies :restart, "service[tomcat7]", :delayed
end

# TODO: default recipe should use hipersonic
# MySQL
include_recipe "mysql::ruby"
include_recipe "database"

mysql_connection_info = {:host => 'localhost', :username => 'root', :password => node['mysql']['server_root_password']}

mysql_database node.liferay.db_name do
    connection mysql_connection_info
    action :create
end

# TODO generate secure password for liferay database

mysql_database_user node.liferay.db_user  do
    connection mysql_connection_info
    database_name node.liferay.db_name
    password node.liferay.db_password
    host node.mysql.bind_address
    action :grant
end

template "#{node.liferay.home}/portal-ext.properties" do
    source "properties.erb"
    owner node.tomcat.user
    group node.tomcat.group
    variables(
        :properties => node.liferay.portalExtProperties
    )
    notifies :restart, "service[tomcat7]", :delayed
end

template "#{node.liferay.home}/system-ext.properties" do
    source "properties.erb"
    owner node.tomcat.user
    group node.tomcat.group
    variables(
        :properties => node.liferay.systemExtProperties
    )
    notifies :restart, "service[tomcat7]", :delayed
end

