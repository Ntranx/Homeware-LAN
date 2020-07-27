#!/bin/bash

# exec 1>logs/upgrader_`date +%s`.log 2>&1

echo "The upgrader has started.\r\n"

#Pull from the repository
sudo git pull

# echo "\r\nThe installations file has been created.\r\n"

  #
  # #Intall the new services
  sudo cp configuration_templates/homeware.service /lib/systemd/system/
  sudo cp configuration_templates/homewareMQTT.service /lib/systemd/system/
  sudo cp configuration_templates/homewareTasks.service /lib/systemd/system/
  sudo cp configuration_templates/homewareRedis.service /lib/systemd/system/
  #
  # #Install redis
  sudo pip3 install redis
  sudo mkdir redis
  cd redis
  wget http://download.redis.io/redis-stable.tar.gz
  tar xvzf redis-stable.tar.gz
  cd redis-stable
  sudo make
  sudo make install
  #
  # #Get current sudo crontab
  sudo crontab -l > copy
  # #Set the new cron job up
  echo "@reboot sudo systemctl start homewareMQTT" >> copy
  echo "@reboot sudo systemctl start homewareTasks" >> copy
  echo "@reboot sudo systemctl start homewareRedis" >> copy
  # #Save the cron file
  sudo crontab copy
  rm copy
  #
  # echo "v0.6\r\n" >> installations.txt
   echo "v0.6 dependencies have been installed.\r\n"

#Start services
sudo systemctl restart homewareMQTT
sudo systemctl restart homewareTasks
sudo systemctl restart homewareRedis
sudo systemctl restart homeware

echo "\r\The upgrader has finished.\r\n"
