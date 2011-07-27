class File
  class << self
    def find(*args)
      require 'ostruct'
      input_query, filelist = {}, []
      if args.length == 1 && args[0].class == Hash
        input_query = args[0]
      elsif args.length >= 1
        if args.length > 3
          raise("Too many arguments\nCorrect arguments: path, ext, filename\n")
        end
        input_query[:path] =
          input_query[:ext] = args[1] if args[1]
        input_query[:filename] = args[2] if args[2]
      end

      query = OpenStruct.new({:path => nil, :ext => "*", :filename => "*"}.merge(input_query))
      if query.path == nil
        raise("Argument 'path' not given")
      end
      query.ext.to_a.each{ |e|
        e[/\A\./] ? e = e[1..e.length-1] : e = e
        #        query.filename.to_a.each{ |f|
        query.path[/\\\z/] ? query.path = query.path[0..query.path.length - 2] : query.path = query.path
        filelist = filelist + Dir[ File.join(query.path.split(/\\/), "**", "#{query.filename}.#{e}") ]
      }
      #      }
      filelist
    end
  end
end

namespace :file do
  task :read do
    txt_files = File.find(:path =>"f:/exam_app/public/txts", :ext => [".txt"])
    match_file = File.open("f:/exam_app/public/matching.txt","rb")
    match_contents=""
    match_contents=match_file.readlines
    txt_files.each do |file|
      puts "begin to read"  
      ordinary_file=File.open(file,"rb")
      contents = ""
      contents =ordinary_file.readlines
      content1= (contents.to_s.split(" ")-(contents.to_s.split(" ")-match_contents.to_s.split(" ")))
      n=0
      match_contents.each do |match_content|
        puts match_content
        if (content1-match_content.split) !=content1
          n +=1
          puts n
        end
      end
      if n>10
        FileUtils.cp file, "f:/exam_app/public/matches/#{file.split("/").reverse[0]}"
      end
      ordinary_file.close
      puts "reade  over,and read next"
    end
    match_file.close
  end

  task :delete_words do
    txt_files = File.find(:path =>"f:/exam_app/public/txts", :ext => [".txt"])
    txt_files.each do |file|
      puts "begin to read"
      match_file=File.open("f:/exam_app/public/matching.txt","rb")
      match_contents=""
      match_contents=match_file.readlines
      ordinary_file=File.open(file,"rb")
      contents = ""
      contents =ordinary_file.readlines
      content1= (contents.to_s.split(" ")-(contents.to_s.split(" ")-match_contents.join(" ").split(" ")))
      leave_content=match_contents.join(" ").split(" ")-content1
      match_file.close
      leave_file=File.open("f:/exam_app/public/matching.txt","w+")
      leave_file.puts("#{leave_content.join(" ")}")
      leave_file.close
      puts "reade  over,and read next"
    end
  end
end
