#!/bin/bash
database_username_consul=consul
database_password_consul=consul
database_username_consul_gilt=consul_gilt
database_password_consul_gilt=consul_gilt
database_name_consul_development=consul_development
database_name_consul_test=consul_test
database_name_consul_development_gilt=consul_development_gilt
database_name_consul_test_gilt=consul_test_gilt

# drop old user and database
sudo -u postgres psql -c "DROP DATABASE $database_name_consul_development;"
sudo -u postgres psql -c "DROP DATABASE $database_name_consul_test;"
sudo -u postgres psql -c "DROP USER $database_username_consul;"

# create new database user
sudo -u postgres psql -c "CREATE USER $database_username_consul WITH SUPERUSER PASSWORD '$database_password_consul';"

# delete old project
sudo rm -Rf /opt/ruby-projects/consul
sudo mkdir /opt/ruby-projects
sudo chmod -R 0777 /opt/ruby-projects
sudo chmod -R 0777 /var/lib/gems

# clone consul
cd /opt/ruby-projects
sudo git clone https://github.com/consul/consul.git
cd consul
sudo gem install bundler:1.17.1
sudo bundle install

# configure database yaml
sudo cp config/database.yml.example config/database.yml
sudo cp config/secrets.yml.example config/secrets.yml
sudo sed -i "s/username:/username: $database_username_consul/g" config/database.yml
sudo sed -i "s/password:/password: $database_password_consul/g" config/database.yml

# install application - role test
# roles : development, staging, preproduction, production , test

sudo bin/rake db:create
sudo bin/rake db:migrate
sudo bin/rake db:dev_seed
sudo RAILS_ENV=test rake db:setup

echo ""
echo "Consul Installation completed"
echo "to run the consul server use:"
echo "cd /opt/ruby-projects/consul"
echo "sudo bin/rails s"

echo ""
read -p "Press Enter to exit"

