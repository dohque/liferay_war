#
# Liferay default attributes
#

node.default["liferay"]["db_user"] = "liferay"
node.default["liferay"]["db_password"] = "liferay"
node.default["liferay"]["db_name"] = "liferay"
node.default["liferay"]["db_host"] = node.mysql.bind_address

node.default["liferay"]["deps"] = 'http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.1.1%20GA2/liferay-portal-dependencies-6.1.1-ce-ga2-20120731132656558.zip'
node.default["liferay"]["war"] = 'http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.1.1%20GA2/liferay-portal-6.1.1-ce-ga2-20120731132656558.war'
node.default["liferay"]["bundle"] = 'http://sourceforge.net/projects/lportal/files/Liferay%20Portal/6.1.1%20GA2/liferay-portal-tomcat-6.1.1-ce-ga2-20120731132656558.zip'

node.default["liferay"]["tomcat"]["defaults"] = {
'TOMCAT7_USER' => 'tomcat7',
'TOMCAT7_GROUP' => 'tomcat7',
'JAVA_OPTS' => '"-Djava.awt.headless=true -XX:+UseConcMarkSweepGC -Dfile.encoding=UTF8 -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xmx1024m -XX:MaxPermSize=256m -Dexternal-properties=/var/lib/liferay/portal-ext.properties"'
}

node.default["liferay"]["nginx_site"]["server_name"] = "localhost"
node.default["liferay"]["nginx_site"]["ssl_certificate"] = "/etc/ssl/private/liferay.crt"
node.default["liferay"]["nginx_site"]["ssl_certificate_key"] = "/etc/ssl/private/liferay.key"
node.default["liferay"]["nginx_site"]["proxy_pass"] = "http://localhost:8080"

node.default["liferay"]["portalExtProperties"] = {
'liferay.home' => '/var/lib/liferay',

'jdbc.default.driverClassName' => 'com.mysql.jdbc.Driver',
'jdbc.default.url' => "jdbc:mysql://#{node.liferay.db_host}/#{node.liferay.db_name}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false",
'jdbc.default.username' => node.liferay.db_user,
'jdbc.default.password' => node.liferay.db_password,

'dl.file.max.size' => 10240000,

# Session timeout
'session.timeout' => 60,
'session.timeout.warning' => 1,
'session.timeout.auto.extend' => true,

'company.security.auth.type' => 'screenName',

# Reminder queries turned off
'users.reminder.queries.enabled' => false,

# Terms of use turned off
'terms.of.use.required' => false,

'schema.run.minimal' => true,

#will place SBI here
'default.guest.public.layout.column-2' => '',

'browser.launcher.url' => '',

'setup.wizard.enabled' => false
}

node.default["liferay"]["systemExtProperties"] = {
'locales' => 'ru_RU,en_EN',
'user.country' => 'RU',
'user.language' => 'ru',
'locale.default.request' => 'true'
}

