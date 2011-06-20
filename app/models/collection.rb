class Collection < ActiveRecord::Base

  COLLECTION_PATH = "/collections"
  
  def self.generate_collection(user_id)
    collection = Collection.create(:user_id => user_id)
    collection.collction_url = collection.generate_collection_url(collection.generate_collection_xml)
    collection.save
    return collection
  end

  def generate_collection_url(str)
    dir = "#{Rails.root}/public" + COLLECTION_PATH
    unless File.directory?(dir)
      Dir.mkdir(dir)
    end
    file_name = "/#{self.id}.xml"
    url = dir + file_name
    f=File.new(url,"w")
    f.write("#{str.force_encoding('UTF-8')}")
    f.close
    return file_name
  end

  def generate_collection_xml
    content = "<?xml version='1.0' encoding='UTF-8'?>"
    content += <<-XML
      <collection id='#{self.id}'>
        <problems></problems>
      </collection>
    XML
    return content
  end

end
