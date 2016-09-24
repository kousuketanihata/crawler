# coding: utf-8
require 'bundler/setup'
# require 'sinatra'
require 'capybara/poltergeist'
require 'extractcontent'
require 'open-uri'
require 'active_support'
require 'active_record'
require 'feedlr'
require 'yaml'
require 'uri'
require 'nokogiri'

# get '/' do
#   puts "hello world"

#       erb :index
# end


# post 'save/user' do
#   puts "hello world"
# end
def fetch_urls_from_feedly
  yaml = YAML.load_file('env.yaml')
  client = Feedlr::Client.new(oauth_access_token: yaml['account']['feedly']['access_token'])
  client.user_subscriptions.map{|m|
    # puts m.id
    hotentries = client.stream_entries_contents(m.id, :count => 5 ).items
    return hotentries
  };
end


feedly = fetch_urls_from_feedly

urls   = []
titles = []
bodies = []

feedly.each do |single|
  # puts single.alternate.first.href
  urls.push( single.alternate.first.href )
end

urls.each { |url|
  open(url) do |io|
    html = io.read
    body, title = ExtractContent.analyse(html)
      titles.push(title)
      bodies.push(body)
  end
}

config = YAML.load_file( 'env.yaml' )
p config["db"]["development"]

ActiveRecord::Base.establish_connection(config["db"]["development"])

class Mail < ActiveRecord::Base

end

# 保存する

5.times{|time|
  mail         = Mail.new
  mail.url     = urls[time]
  mail.title   = titles[time]
  mail.content = bodies[time]
  mail.save
}


def save_content(urls, titles, bodies)
  
end



def fetch_html
        Capybara.register_driver :poltergeist do |app|
          Capybara::Poltergeist::Driver.new(app, {:js_errors => false, :timeout => 1000 })
        end
        session = Capybara::Session.new(:poltergeist)
        session.visit "http://www.b-ch.com/ttl/index.php?ttl_c=2277"
        puts session.status_code
        puts '各話タイトル'

        # 「各話あらすじ」をクリックする => onClickが実行される
        session.find('div.ttlinfo-menu').all('ul')[0].all('li')[2].find('a').click

        # 第１話タイトル
        puts session.find('div#ttlinfo-stry').find('dt').text

        # 第２話タイトル〜
        # 最終話は動的に取得してもよいかも
        2.upto(44) do |num|
          # onClickイベント　ページネーションクリック
          session.find('div#ttlinfo-stry').find('p#page-list').click_link num.to_s
          sleep 3 # ajaxで内容が書き換えられる間少し待つ。待ち時間は適当...
          puts session.find('div#ttlinfo-stry').find('dt').text
        end

        return html
end

def parse_content(html)
        content, title = ExtractContent.analyse(html)
        puts title
        return title, content
end

# FacebookEvaluation
class FacebookEvaluation
        def initialize(search_url = "http://www.itmedia.co.jp/news/articles/1609/12/news104.html")
          count_facebook_like_base_uri = "http://graph.facebook.com/?id="
          puts count_facebook_like_base_uri + search_url
          facebook = get_json(count_facebook_like_base_uri + search_url)
          puts facebook["share"]["share_count"]
          return facebook["share"]["share_count"]
        end

        def get_json(location, limit = 10)
          raise ArgumentError, 'too many HTTP redirects' if limit == 0
          uri = URI.parse(location)
          begin
            response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
              http.open_timeout = 5
              http.read_timeout = 10
              http.get(uri.request_uri)
            end
            case response
            when Net::HTTPSuccess
              json = response.body
              JSON.parse(json)
            when Net::HTTPRedirection
              location = response['location']
              warn "redirected to #{location}"
              get_json(location, limit - 1)
            else
              puts [uri.to_s, response.value].join(" : ")
              # handle error
            end
          rescue => e
            puts [uri.to_s, e.class, e].join(" : ")
            # handle error
          end
        end
        # FacebookEvaluation ここまで
end
# dbへ保存する系
class Model
end

class User < Model
        # ハッシュを入れる
        def save(user)

        end

        def stop(user_id)

        end
end

# class Article < Model

# end

class Nikkei
        def initialize(args)

        end

        def login

        end
end


class NewsPicks
        def initialize(args)
          login(username, password)
        end

        def login(username, password)

        end
end