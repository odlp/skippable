require "digest"
require "fileutils"

module Skippable
  class FileDigest
    def initialize(path:)
      @path = path
    end

    def changed?
      current_digest != cached_digest
    end

    def update_cached_digest
      unless File.directory?(File.dirname(cached_digest_path))
        FileUtils.mkdir_p(File.dirname(cached_digest_path))
      end

      File.write(cached_digest_path, current_digest)
    end

    private

    attr_reader :path

    def current_digest
      @current_digest ||= Digest::SHA256.file(path).hexdigest
    end

    def cached_digest
      if File.exist?(cached_digest_path)
        File.read(cached_digest_path)
      end
    end

    def cached_digest_path
      File.join("tmp", "skippable", path)
    end
  end
end
