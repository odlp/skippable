require "skippable/file_digest"

module Skippable
  class Task
    def initialize(name:, command:, paths:)
      @name = name
      @command = command
      @paths = paths
    end

    def call
      if file_digests.none?(&:changed?)
        puts "Skipping #{name}..."
        return 0
      end

      execute_command

      if $?.success?
        file_digests.each(&:update_cached_digest)
      end

      $?.exitstatus
    end

    private

    attr_reader :name, :command, :paths

    def execute_command
      system(command)
    end

    def file_digests
      @file_digests ||= paths.map { |path| FileDigest.new(path: path) }
    end
  end
end
