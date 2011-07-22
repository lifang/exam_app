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
        query.filename.to_a.each{ |f|
          query.path[/\\\z/] ? query.path = query.path[0..query.path.length - 2] : query.path = query.path
          filelist = filelist + Dir[ File.join(query.path.split(/\\/), "**", "#{f}.#{e}") ]
        }
      }
      filelist
    end
  end
end

namespace :files do
  task(:read_file => :environment) do
    txt_files = File.find(:path => Constant::TXTS_PATH, :ext => [".txt"])
    txt_files.each do |file|
      f= File.open(file,"rb")
      str = ""
      str = f.readlines
      str.each do |str1|
        puts str1
      end
      f.close
      puts "reade#{file}over,and read next"
    end
  end
end
