require "yaml"
require "skippable/task"

module Skippable
  class TaskLoader
    def by_name(task_name)
      task_config = config.fetch("tasks").fetch(task_name)

      Task.new(
        name: task_name,
        command: task_config.fetch("command"),
        paths: task_config.fetch("paths"),
      )
    end

    private

    def config
      @config ||= YAML.load_file(".skippable.yml")
    end
  end
end
