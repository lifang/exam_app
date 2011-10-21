# encoding: utf-8
require 'rexml/document'
include REXML
namespace :check do
  desc "rate paper"
  task(:title => :environment) do
    file_path="#{Constant::PUBLIC_PATH}/papers"
    def traverse_dir(file_path)
      if File.directory? file_path
        Dir.foreach(file_path) do |file|
          if file!="." and file!=".."
            traverse_dir(file_path+"/"+file){|x| yield x}
          end
        end
      else
        yield  file_path
      end
    end
    def write_xml(url,doc)
      file = File.open(url,"w")
      file.write(doc)
      file.close
    end
    def modify_tag(block,type)
      block.elements["problems"].each_element do |problem|
        problem.elements["questions"].each_element do |question|
          question.elements["tags"].text = ""
          unless question.elements["tags"].text=~ /#{type[0]}/
            question.elements["tags"].text="#{question.elements["tags"].text} #{type[0]}"
            tag = Tag.create_tag(type)
            que = Question.find(question.attributes['id'].to_i)
            que.question_tags(tag) if que
          end unless question.nil?
        end unless problem.elements["questions"].nil?
        if problem.attributes['id'] != "" and problem.attributes['id'] != nil and problem.attributes['id'] != "0"
          pro = Problem.find(problem.attributes['id'].to_i)
          pro.update_problem_tags if pro
        end
        puts "seccess"
      end unless block.elements["problems"].nil?
    end

    traverse_dir(file_path){|f|
      puts f.to_s()
      #      if f.to_s() =~ /\.xml$/
      doc= REXML::Document.new(File.new(f)).root
      NUM=0
      doc.elements["blocks"].each_element do |block|
        NUM +=1
        title=block.elements["base_info/title"].text
        if title=~ /Writing/
          modify_tag(block,["写作"])
        elsif title=~ /Reading/ && NUM==2
          modify_tag(block,["快速阅读"])
        elsif title=~ /Reading/ && NUM==4
          modify_tag(block,["阅读"])
        elsif title=~ /Listening/
          modify_tag(block,["听力"])
        elsif title=~ /Translation/
          modify_tag(block,["翻译"])
        elsif title=~ /Cloze/
          modify_tag(block,["完形填空"])
        end
      end unless doc.elements["blocks"].nil?
      js_file=Hash.from_xml(doc.to_s).to_json
      write_xml("#{Constant::PUBLIC_PATH}/paperjs/#{doc.attributes['id']}.js","papers = "+js_file)
      write_xml(f,doc)
      #      end
    }
  end
end

