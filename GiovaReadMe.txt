# because of sphinx we use mysql also for development.
# remember to start mysqld as first thing:
su admin -c 'mysql.server start'

# remember to start sphinx before starting the server:
rake thinking_sphinx:start
rails server

# list rake tasks:
rake -T

