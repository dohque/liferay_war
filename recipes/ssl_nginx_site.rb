#
# Recipe for integration of liferay with nginx
# manages liferay site in nginx
#

service "nginx" do
  supports :status => true, :start => true, :stop => true, :restart => true, :reload => true
  action :nothing
end

# TODO may be read from some kind of properties
template "/etc/nginx/sites-available/ssl_liferay" do
  source "ssl_liferay_site.erb"
  owner "root"
  variables(
    :site => node.liferay.nginx_site
  )
  notifies :reload, "service[nginx]", :delayed  
end


