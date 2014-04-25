[ -d "/tmp/cookbooks1" ] && rm -rf /tmp/cookbooks1
berks vendor /tmp/cookbooks1
chef-solo -c solo.rb -j solo.json
