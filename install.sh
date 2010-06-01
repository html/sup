gem install -v=2.3.5 rails --no-rdoc --no-ri
rake gems:install
git submodule init
git submodule update
rake db:migrate

