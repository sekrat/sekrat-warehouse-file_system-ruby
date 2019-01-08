require 'base64'

require 'sekrat/warehouse/file_system/version'
require 'sekrat/warehouse/base'

module Sekrat
  module Warehouse
    class FileSystem
      include Base

      attr_reader :basedir

      def initialize(basedir: File.expand_path('.'))
        @basedir = basedir
      end

      def ids
        Dir["#{basedir}/**/*"].
          select {|path| File.file?(path)}.
          map {|path| path.gsub(/^#{Regexp.escape(basedir)}\//, '')}
      end

      def store(id, data)
        begin
          file = filename(id)
          FileUtils.mkdir_p(File.dirname(file))
          out = File.open(file, 'w')
          out.write(Base64.encode64(data))
          out.close
        rescue
          raise Sekrat::StorageFailure.new("couldn't save")
        end
      end

      def retrieve(id)
        file = filename(id)
        raise Sekrat::NotFound.new("'#{id}'") unless File.exist?(file)

        begin
          Base64.decode64(File.read(file))
        rescue
          raise Sekrat::Error.new("could not read secret '#{id}'")
        end
      end

      private
      def filename(id)
        File.expand_path(id, basedir)
      end
    end
  end
end
