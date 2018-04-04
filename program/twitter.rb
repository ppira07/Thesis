require 'twitter' 

# ref: https://github.com/sferik/twitter/issues/709#issuecomment-159121199
class HTTP::URI
  def port
    443 if self.https?
  end
end

client = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

dic = {}

File.open('newtweet.txt', 'a') do |f|
  client.sample(language: 'ja') do |object|
    if object.is_a?(Twitter::Tweet) && object.text =~ /(\(.+?\))/
    if dic.has_key?($1)
      unless dic[$1].nil?
        f.write dic[$1]
        dic[$1] = nil
      end
      f.write object.text
      else
        dic[$1] = object.text
      end
    end
  end
end
