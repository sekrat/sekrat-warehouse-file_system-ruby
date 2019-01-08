require 'base64'

require 'sekrat/warehouse/file_system/version'
require 'sekrat/warehouse/base'

module Sekrat
  module Warehouse

    # A Sekrat::Warehouse implementation
    class FileSystem
      include Base

      attr_reader :basedir

      # Instantiate a new FileSystem warehouse with a base directory for secret
      # storage.
      # @param basedir: [String] the filesystem directory to use as the base for
      #   secret storage
      def initialize(basedir: File.expand_path('.'))
        @basedir = basedir
      end

      # Get the list of secret IDs known to the warehouse
      # @return [Array<String>] the secret IDs
      def ids
        Dir["#{basedir}/**/*"].
          select {|path| File.file?(path)}.
          map {|path| path.gsub(/^#{Regexp.escape(basedir)}\//, '')}
      end

      # Given a secret ID and secret data, save the data to the filesystem,
      # indexed by the ID.
      #
      # New entries are saved outright, and reusing an ID will overwrite the
      # old data.
      # @param id [String] the secret ID
      # @param data [String] the secret data
      # @return [String] the original data passed in
      # @raise [Sekrat::StorageFailure] if there any any problems along the way
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

      # Given a secret ID, attempt to retrieve and return the secret data.
      # @param id [String] the secret ID
      # @return [String] the secret data
      # @raise [Sekrat::NotFound] if the warehouse does not contain the
      #   requested secret
      # @raise [Sekrat::Error] if there any unspecific retrieval issues
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
