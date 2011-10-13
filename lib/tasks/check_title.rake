# encoding: utf-8
require 'rexml/document'
include REXML
namespace :check do
  desc "rate paper"
  task(:title => :environment) do
    file_path="E:/gankao/public/collections"
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
      file = File.open(url,"w+")
      file.write(doc)
      file.close
    end
    def modify_tag(block,type)
      block.elements["problems"].each_element do |problem|
        problem.element["questions"].each_element do |question|
          unless question.elements["tags"].text=~ /#{type}/
            question.elements["tags"].text="#{question.elements["tags"].text} #{type}"
            tag = Tag.create_tag(type)
            que = Question.find(question.attributes['id'].to_i)
            que.question_tags(tag)
          end unless question.nil?
        end unless problem.element["questions"].nil?
        problem = Problem.find(problem.attributes['id'].to_i)
        problem.update_problem_tags
      end unless block.elements["problems"].nil?
    end

    traverse_dir(file_path){|f|
      if f.to_s() =~ /\.xml$/
        doc= REXML::Document.new(File.new(f)).root
        NUM=0
        doc.elements["blocks"].each_element do |block|
          NUM +=1
          title=block.elements["base_info/title"].text
          if title=~ /writing/
            modify_tag(block,"写作",doc,f)
          elsif title=~ /reading comprehension/&& NUM==2
            modify_tag(block,"快速阅读",doc,f)
          elsif title=~ /reading comprehension/&& NUM==4
            modify_tag(block,"阅读",doc,f)
          elsif title=~ /listening comprehension/
            modify_tag(block,"听力",doc,f)
          elsif title=~ /translation/
            modify_tag(block,"翻译",doc,f)
          elsif title=~ /cloze/
            modify_tag(block,"完形填空",doc,f)
          end
        end unless doc.elements["blocks"].nil?
        js_file=Hash.from_xml(doc.to_s).to_json
        write_xml("#{Constant::PUBLIC_PATH}/paperjs/#{doc.attributes['id']}.js","papers = "+js_file)
        write_xml(file_path,doc)
      end
    }
  end
end

