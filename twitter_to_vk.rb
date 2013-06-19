#!/usr/bin/ruby

require 'yaml'
require 'vk-ruby'
require 'twitter'

class TwitterToVkReposter
  @@latest_repost_id_file_name = "most_recent_saved_post_id.txt"

  def initialize
    @config           = YAML.load_file("config.yaml")
    @latest_repost_id = open(@@latest_repost_id_file_name).read
    @posts            = read_posts_from_twitter()
    @vk_app           = VK::Application.new access_token: @config[:vk][:oauth_token]
  end

  def read_posts_from_twitter()
    Twitter.configure do |config|
      config.consumer_key       = @config[:twitter][:consumer_key]
      config.consumer_secret    = @config[:twitter][:consumer_secret]
      config.oauth_token        = @config[:twitter][:oauth_token]
      config.oauth_token_secret = @config[:twitter][:oauth_token_secret]
    end
    if @latest_repost_id.length > 0
      return Twitter.user_timeline("spajic1", :since_id => @latest_repost_id)
    end
      return Twitter.user_timeline("spajic1", :count => 10)
  end

  def tags_of_post(post)
    post.entities.hashtags.collect{|x| x.text}
  end

  def expanded_urls_of_post(post)
    post.urls.collect{|x| x.expanded_url}
  end

  def replace_urls_with_expanded_urls(post, text)
    urls = post.urls
    urls.each do |url|
      text.sub! url.url, url.expanded_url
    end
    return text
  end

  def post_message_to_vk_wall_by_post(post)
    text = post.text
    text = replace_urls_with_expanded_urls(post, text)
    @vk_app.wall.post message: text
  end

  def save_most_recent_post_id_to_file()
    if @posts.length > 0
      File.open(@@latest_repost_id_file_name, "w") {
          |f| f.write( @posts[0].id ).to_s
      }
    end
  end

  def satisfies_conditions(post)
    return false if not expanded_urls_of_post(post).any? {|s| s.include?('gip.is')}
    return true
  end

  def do_reposts
    @posts.each do |post|
      post_message_to_vk_wall_by_post(post) if satisfies_conditions(post)
    end
    save_most_recent_post_id_to_file()
  end

end

TwitterToVkReposter.new().do_reposts()