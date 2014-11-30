#encoding:utf-8
require 'nokogiri'
require 'open-uri'


#   得到9个相关数据
def get_search_result(keyword)
	keyword.force_encoding('utf-8')
	surl='http://www.baidu.com/baidu?word='+ keyword+'&ie=utf-8'
	url=URI.encode(surl.strip)
	data=open(url)
	doc=Nokogiri::HTML(data)
	a=Array.new(9)
	counter=0
	datas=doc.css('a').each do |link|
		hrefs=link['href']
                contents=link.content
                	unless  hrefs == nil
				flag=hrefs.match('wd=')
				unless flag==nil
					flag2=hrefs.match('rsv_ers')
					unless  flag2 ==nil
						puts "#{link.content},#{link['href']}"
						a[counter]=link.content
						counter+=1
				end
			end
		end
	end
	return a
end

#取搜索界面的前十个title和url
def get_detail_title(keywords)
	keywords.force_encoding('utf-8')
        surl='http://www.baidu.com/baidu?word='+ keywords+'&ie=utf-8'
        url=URI.encode(surl.strip)
        data=open(url)
        doc=Nokogiri::HTML(data)
	title=Array.new(10)
	t_link=Array.new(10)
	counter=0
	datas=doc.css('h3/a').each do |link|
		hrefs=link['href']
		contents=link.content 
		unless  hrefs == nil
			#unless  flag==nil
			puts contents
			puts hrefs
			title[counter]=contents
			t_link[counter]=hrefs
			counter+=1
			#end

		end
	end
	return title,t_link
end

#创建5个线程进行数据搜索
def create_threads(relatedarray)
	t1=Thread.new{create_loop(relatedarray[0],1112);create_loop(relatedarray[1],1112)}
        t2=Thread.new{create_loop(relatedarray[2],1112);create_loop(relatedarray[3],1112)}
	t3=Thread.new{create_loop(relatedarray[4],1112);create_loop(relatedarray[5],1112)}
	t4=Thread.new{create_loop(relatedarray[6],1112);create_loop(relatedarray[7],1112)}
	t5=Thread.new{create_loop(relatedarray[8],1112)}
	t1.join
	t2.join
	t3.join
	t4.join
	t5.join

end

#进行循环
def create_loop(keyword,nums)
	counter=0
	i=0
	#relatewd=get_search_result(keyword)
	#for word in relatewd
	#执行循环不会更新word值长度
	#relatewd.each do |word|
		#relatewd=relatewd|(get_search_result(word))
		#counter=relatewd.length
		#puts relatewd
		#puts counter
		#puts word
		#if counter>=nums
			#puts counter
			#break
		#end
	relatewd=Array.new
	loop do
		if i==0
			relatewd=relatewd|(get_search_result(keyword))
			get_detail_title(keyword)
			i+=1
                	counter=relatewd.length
			#puts counter
			#puts i
			if(counter>=nums)
				#puts counter
				break
			end
		else
			relatewd=relatewd|(get_search_result(relatewd[i-1]))
			get_detail_title(relatewd[i-1])
                        i+=1
                        counter=relatewd.length
			#puts relatewd.size
			#puts counter
			#puts i
                        if(counter>=nums)
                                #puts counter
                                break
                        end

		end
	end
	


end

relatedword=get_search_result('艺龙')
create_threads(relatedword)
#create_loop('艺龙',100)
#get_detail_title('艺龙')
