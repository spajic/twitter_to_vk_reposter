twitter_to_vk_reposter
======================

Repost from twitter to VK
-----------------------------

This simple script is based on 
  * [Twitter API] (https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline) 
  * [VK API] (http://vk.com/developers.php?id=-1_37230422&s=1)
  * [vk-ruby] (https://github.com/zinenko/vk-ruby) library 

Usage
---------------------------------------
1. Install ruby
  1. [RubyInstaller for Windows] (http://rubyinstaller.org/downloads)
  2. [DevKit] (https://github.com/oneclick/rubyinstaller/wiki/development-kit) may help to build gems. 
      Read instruction to setup
2. Check that ruby works well with SSL 
  (I encountered some issues, [this] (https://gist.github.com/fnichol/867550) helped, 
[more info](http://railsapps.github.io/openssl-certificate-verify-failed.html))
3. Get VK ouath token (read [VK documentation] (http://vk.com/developers.php?id=-1_37230422&s=1) for that)
4. Create file config.yaml by example, fill twitter user_name and VK oauth token
5. Run script (as for now script reposts only posts that are tagged with #vk and #gipis, 
  it can be simply modified through code)

How to get VK oauth token
-----------------------------------------
1. Register Desktop application in VK, you will get APP_ID
2. Open the following address in browser:
<pre>
  https://oauth.vk.com/authorize? 
     client_id=APP_ID& 
     scope=wall,offline&
     redirect_uri=http://oauth.vk.com/blank.html& 
     display=page& 
     response_type=token
</pre>
  In response you will get oauth token.

Regular runs
------------------------------------------
  * Create something like CRON or Windows task planner task.
  * Modify script so that it works continiuosly and perform reposts after some sleeping
