require "termquickrpg/bootstrap"
require "termquickrpg/version"

module TermQuickRPG
  class << self
    def run(game_dir, main_script_filename = "main.script.rb")
      raise "Expected game_dir" unless game_dir

      main_path = File.join(game_dir, main_script_filename)
      raise "Main script executable not found: #{main_path}" unless File.exist?(main_path)

      bootstrap = Bootstrap.new(game_dir: game_dir, launch: -> { eval(File.read(main_path)) })
      bootstrap.run
    end
  end
end
