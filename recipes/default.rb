#
# Cookbook Name:: liferay_war
# Recipe:: default
#
# Copyright 2013, PilinSolutions
#

# install tomcat native libraries
package "libtcnative-1" do
    action :install
end

package "tomcat7" do
    action :install
end

service "tomcat7" do
    supports :status => true, :restart => true
    action :nothing
end

package "unzip" do
    action :install
end

['activation.jar',  'hsql.jar', 'jta.jar', 'jutf7.jar', 'mysql.jar', 'portal-service.jar', 'postgresql.jar',
'ccpp.jar', 'jms.jar', 'jtds.jar', 'mail.jar', 'persistence.jar', 'portlet.jar', 'support-tomcat.jar'].each do |lib|

    cookbook_file "/var/lib/tomcat7/common/#{lib}" do
        source "#{lib}"
        owner 'tomcat7'
        group 'tomcat7'
        action :create_if_missing
        notifies :restart, "service[tomcat7]", :delayed
    end
end

template "/etc/default/tomcat7" do
    source "properties.erb"
    owner "root"
    variables(
        :properties => node.liferay.tomcat.defaults
    )
    notifies :restart, "service[tomcat7]", :delayed
end

directory "/var/lib/liferay" do
   owner 'tomcat7'
   group 'tomcat7'
end

directory "/var/lib/tomcat7/webapps/ROOT" do
    action :delete
    recursive true
    not_if { File.exists?("/var/lib/tomcat7/webapps/ROOT.war") }
end

remote_file "/var/lib/tomcat7/webapps/ROOT.war" do
    source node.liferay.war
    owner 'tomcat7'
    group 'tomcat7'
    action :create_if_missing
    notifies :restart, "service[tomcat7]", :delayed
end

#remote_file "/tmp/liferay-tomcat-bundle.zip" do
#   source node.liferay.bundle
#   action :create_if_missing
#end

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

template "/var/lib/liferay/portal-ext.properties" do
    source "properties.erb"
    owner "tomcat7"
    group "tomcat7"
    variables(
        :properties => node.liferay.portalExtProperties
    )
    notifies :restart, "service[tomcat7]", :delayed
end

template "/var/lib/liferay/system-ext.properties" do
    source "properties.erb"
    owner "tomcat7"
    group "tomcat7"
    variables(
        :properties => node.liferay.systemExtProperties
    )
    notifies :restart, "service[tomcat7]", :delayed
end

