module TerraspacePluginGoogle::Interfaces
  class Summary
    include Terraspace::Plugin::Summary::Interface
    include TerraspacePluginGoogle::Clients

    # interface method
    def key_field
      'prefix'
    end

    # interface method
    def download
      bucket = storage.bucket(@bucket)
      bucket.files(prefix: @folder).all do |f|
        file = bucket.file(f.name)
        # Note the f.name already includes the folder
        local_path = "#{@dest}/#{f.name}"
        FileUtils.mkdir_p(File.dirname(local_path))
        file.download(local_path)
      end
    end

    # interface method
    def delete_empty_statefile(key)
      bucket = storage.bucket(@bucket)
      file = bucket.file(key)
      file.delete
    end
  end
end
