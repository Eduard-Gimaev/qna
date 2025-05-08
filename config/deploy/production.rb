# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server "64.227.47.81", user: "deployer", roles: %w{app db web}, primary: true
set :rails_env, "production"


set :ssh_options, {
  keys: %w(/Users/eduardgimaev/.ssh/id_ed25519),
  forward_agent: true,
  auth_methods: %w(publickey),
  port: 2222
}

set :passenger_restart_with_touch, false