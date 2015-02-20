require 'nokogiri'
require "rubygems"
require 'open-uri'
require 'watir'
require 'watir-webdriver'
require 'csv'

def judgeRating(score)
	case score
	when 0
		return 'N'
	when 1..499999
		return 'E'
	when 500000..699999
		return 'D'
	when 700000..799999
		return 'C'
	when 800000..849999
		return 'B'
	when 850000..899999
		return 'A'
	when 900000..949999
		return 'S'
	when 950000..979999
		return 'SS'
	when 980000..999999
		return 'SSS'
	when 1000000
		return 'EXC'
	end
end

day = Time.now
csv_name = format("%04d_%02d_%02d_%02d_%02d.csv", day.year, day.month, day.day, day.hour, day.min).to_s
puts csv_name

mcount = 2

browser = Watir::Browser.new :chrome
	browser.goto('https://p.eagate.573.jp/gate/p/login.html?___REDIRECT=1')

browser.text_field(:id => 'KID').set 'user'
browser.text_field(:id => 'pass').set 'pass'

browser.button(:class => 'login_btn').click

browser.goto('http://p.eagate.573.jp/game/jubeat/prop/p/playdata/music.html')

html = browser.html
doc = Nokogiri::HTML.parse(html, nil, 'UTF-8')

CSV.open(csv_name, "w") do |csv|

	csv << ['Update:', Time.now.to_s]

	puts 'counter=1'

	csv << ['緑Lv', '黄Lv', '赤Lv', '楽曲名', 'BSC', 'BR', 'ADV', 'AR', 'EXT', 'ER']

	doc.css('.music_detail').each do |anchor|

		detail_url = 'http://p.eagate.573.jp/'+anchor[:href]
		browser.goto(detail_url)

		puts 

		browser.wait

		if browser.html.include?('この楽曲はまだプレーしていません')
			browser.goto('http://p.eagate.573.jp/game/jubeat/prop/p/playdata/music.html') #2ページ以降注意
			xpath = '//*[@id="play_music_table"]/tbody/tr[' + (mcount+1).to_s + ']/td[2]/a'
			music_title = browser.link(:xpath=> xpath).text
			bsc_level = 0
			adv_level = 0
			ext_level = 0
			bsc_score = 0
			adv_score = 0
			ext_score = 0

		elsif !browser.html.include?('LEVEL')
			browser.goto(detail_url)

		else
			bsc_level = browser.td(:xpath => '//*[@id="seq_container"]/div[1]/table/tbody/tr[1]/td[2]').text.gsub(/[^0-9]/,"")
			adv_level = browser.td(:xpath => '//*[@id="seq_container"]/div[2]/table/tbody/tr[1]/td[2]').text.gsub(/[^0-9]/,"")
			ext_level = browser.td(:xpath => '//*[@id="seq_container"]/div[3]/table/tbody/tr[1]/td[2]').text.gsub(/[^0-9]/,"")
			music_title = browser.div(:id=> 'contents_caption_text').text
			bsc_score = browser.td(:xpath => '//*[@id="seq_container"]/div[1]/table/tbody/tr[6]/td[2]').text
			adv_score = browser.td(:xpath => '//*[@id="seq_container"]/div[2]/table/tbody/tr[6]/td[2]').text
			ext_score = browser.td(:xpath => '//*[@id="seq_container"]/div[3]/table/tbody/tr[6]/td[2]').text
			if bsc_score.include?('-')
				bsc_score = 0
			end
			if adv_score.include?('-')
				adv_score = 0
			end
			if ext_score.include?('-')
				ext_score = 0
			end
		end

		csv << [bsc_level.to_i, adv_level.to_i, ext_level.to_i, music_title, bsc_score.to_i, judgeRating(bsc_score.to_i), adv_score.to_i, judgeRating(adv_score.to_i), ext_score.to_i, judgeRating(ext_score.to_i)]
		puts music_title
		puts "BSC:", bsc_score, "  ADV:", adv_score, "  EXT:", ext_score
		mcount+=1
	end

	counter=2
	mcount=2

	while counter < 12
		puts counter

		url='http://p.eagate.573.jp/game/jubeat/prop/p/playdata/music.html?sort=&page='+counter.to_s
		browser.goto(url)
		html = browser.html
		doc = Nokogiri::HTML.parse(html, nil, 'UTF-8')

		doc.css('.music_detail').each do |anchor|

		detail_url = 'http://p.eagate.573.jp/'+anchor[:href]
		browser.goto(detail_url)

		puts 

		browser.wait

		if browser.html.include?('この楽曲はまだプレーしていません')
			browser.goto('http://p.eagate.573.jp/game/jubeat/prop/p/playdata/music.html?sort=&page='+counter.to_s) #2ページ以降注意
			xpath = '//*[@id="play_music_table"]/tbody/tr[' + (mcount+1).to_s + ']/td[2]/a'
			music_title = browser.link(:xpath=> xpath).text
			bsc_level = 0
			adv_level = 0
			ext_level = 0
			bsc_score = 0
			adv_score = 0
			ext_score = 0

		elsif !browser.html.include?('LEVEL')
			browser.goto(detail_url)

		else
			bsc_level = browser.td(:xpath => '//*[@id="seq_container"]/div[1]/table/tbody/tr[1]/td[2]').text.gsub(/[^0-9]/,"")
			adv_level = browser.td(:xpath => '//*[@id="seq_container"]/div[2]/table/tbody/tr[1]/td[2]').text.gsub(/[^0-9]/,"")
			ext_level = browser.td(:xpath => '//*[@id="seq_container"]/div[3]/table/tbody/tr[1]/td[2]').text.gsub(/[^0-9]/,"")
			music_title = browser.div(:id=> 'contents_caption_text').text
			bsc_score = browser.td(:xpath => '//*[@id="seq_container"]/div[1]/table/tbody/tr[6]/td[2]').text
			adv_score = browser.td(:xpath => '//*[@id="seq_container"]/div[2]/table/tbody/tr[6]/td[2]').text
			ext_score = browser.td(:xpath => '//*[@id="seq_container"]/div[3]/table/tbody/tr[6]/td[2]').text
			if bsc_score.include?('-')
				bsc_score = 0
			end
			if adv_score.include?('-')
				adv_score = 0
			end
			if ext_score.include?('-')
				ext_score = 0
			end
		end

		csv << [bsc_level.to_i, adv_level.to_i, ext_level.to_i, music_title, bsc_score.to_i, judgeRating(bsc_score.to_i), adv_score.to_i, judgeRating(adv_score.to_i), ext_score.to_i, judgeRating(ext_score.to_i)]
		puts music_title
		puts "BSC:", bsc_score, "  ADV:", adv_score, "  EXT:", ext_score
		mcount+=1
	end
		counter+=1
		mcount=2
	end
end