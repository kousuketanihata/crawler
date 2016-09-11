require 'sinatra'
require 'capybara/poltergeist'



get '/' do
  'Hello world!'
end


post 'save' do
  
end

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