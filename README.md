twitter_to_vk_reposter
======================

Repost from twetter to VK

This simple script is based on 
  * [Twitter API] (https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline) 
  * [VK API] (http://vk.com/developers.php?id=-1_37230422&s=1) and 
  * [vk-ruby library] (https://github.com/zinenko/vk-ruby)

Usage
---------------------------------------
1. Install ruby
2. Check that ruby works well with SSL 
  (I encountered some issues, [this helped:] (https://gist.github.com/fnichol/867550)
3. Get VK ouath token (read [VK documentation] (http://vk.com/developers.php?id=-1_37230422&s=1) for that)
4. Create file config.yaml by example, fill twitter user_name and VK oauth token
5. Run script (as for now script reposts only posts that are tagged with #vk and #gipis, 
  it can be simply modified through code)
