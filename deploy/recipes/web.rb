include_recipe 'deploy'
include_recipe "nginx::service"

Chef::Log.info("Node:")
Chef::Log.warn(node.inspect)

node[:deploy].each do |application, deploy|
  if false && deploy[:application_type] != 'static'
    Chef::Log.debug("Skipping deploy::web application #{application} as it is not an static HTML app")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    app application
    deploy_data deploy
  end

  nginx_web_app application do
    application deploy
    cookbook "nginx"
  end
end
