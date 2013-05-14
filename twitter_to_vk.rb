#!/usr/bin/ruby

require 'json'
require 'open-uri'
require 'net/http'
require 'uri'
require 'yaml'
require 'time'
require 'cgi'
require 'vk-ruby'


class TwitterToVkReposter
  @@latest_repost_time_file_name = "most_recent_saved_post_time.txt"

  def read_lastest_repost_time_from_file_or_set_very_old_time
    very_old_time = 'Mon May 06 16:03:44 +0000 2000'
    time_string = open(@@latest_repost_time_file_name).read.to_s rescue very_old_time
    res = Time.parse( time_string )
    return res
  end

  def obtain_vk_app()
    return VK::Application.new access_token: @config[:vk][:oauth_token]
  end

  def read_posts_from_twitter()
    return JSON.parse(
        open("https://api.twitter.com/1/statuses/user_timeline.json?include_entities=true&screen_name=#{@config[:twitter][:user_name]}&count=10").read.to_s
    )
  end

  def creation_time_of_post(post)
    return Time.parse(post['created_at'])
  end

  def tags_of_post(post)
    return post['entities']['hashtags'].collect{|x| x['text']}
  end

  def urls_of_post(post)
    return post['entities']['urls']
  end

  def expanded_urls_of_post(post)
    return post['entities']['urls'].collect{|x| x['expanded_url']}
  end

  def replace_urls_with_expanded_urls(post, text)
    urls = urls_of_post(post)
    urls.each do |url|
      text.sub! url['url'], url['expanded_url']
    end
    return text
  end

  def construct_text_by_post(post)
    text = post['text']
    text = replace_urls_with_expanded_urls(post, text)
    return text
  end

  def post_message_to_vk_wall_by_post(post)
    @vk_app.wall.post message: construct_text_by_post(post)
  end

  def save_most_recent_post_time_to_file()
    File.open(@@latest_repost_time_file_name, "w") {
        |f| f.write( creation_time_of_post(@posts[0]) ).to_s
    }
  end

  def satisfies_conditions(post)
    return false if creation_time_of_post(post) <= @latest_repost_time
    return false if not expanded_urls_of_post(post).any? {|s| s.include?('gip.is')}
    return true
  end

  def initialize
    @config = YAML.load_file("config.yaml")
    @latest_repost_time = read_lastest_repost_time_from_file_or_set_very_old_time()
    @posts = read_posts_from_twitter()
    @vk_app = obtain_vk_app()
  end

  def do_reposts
    @posts.each do |post|
      post_message_to_vk_wall_by_post(post) if satisfies_conditions(post)
    end
    save_most_recent_post_time_to_file()
  end

end

TwitterToVkReposter.new().do_reposts()