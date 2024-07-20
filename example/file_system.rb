# frozen_string_literal: true

$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require "shell_shock/context"
require "find"
require "pathname"

class Finder
  attr_reader :files

  def initialize(path)
    @path = path
  end

  def refresh(pattern)
    files = []
    here = Pathname.new(File.expand_path(@path))
    Find.find(File.expand_path(@path)) do |p|
      if File.basename(p).start_with?(".")
        Find.prune
      else
        path = Pathname.new(p).relative_path_from(here).to_s
        files << path if path.start_with?(pattern) && yield(p)
      end
    end
    files
  end
end

class CatFileCommand
  include ShellShock::Logger

  def initialize(path)
    @finder = Finder.new path
  end

  def usage
    "<file name>"
  end

  def help
    "displays the content of a file"
  end

  def completion(text)
    log { "cat command completing \"#{text}\"" }
    @finder.refresh(text) { |path| File.file? path }
  end

  def execute(path = nil)
    return unless path

    File.open(path) { |f| f.each_with_index { |l, i| puts "#{i + 1}: #{l}" } }
  end
end

class ChangeDirectoryCommand
  include ShellShock::Logger

  def initialize(path)
    @path = path
    @finder = Finder.new path
  end

  def usage
    "<directory name>"
  end

  def help
    "switches to a new shell context in the specified directory"
  end

  def completion(text)
    log { "cd command completing \"#{text}\"" }
    @finder.refresh(text) { |path| path != "." and File.directory? path }
  end

  def execute(text = nil)
    return unless text

    log { "pushing new shell in \"#{text}\"" }
    DirectoryContext.new("#{@path}/#{text}").push
  end
end

class DirectoryContext
  include ShellShock::Context

  def initialize(path)
    @prompt_text = "#{path} > "
    @commands = {
      "cd" => ChangeDirectoryCommand.new(path),
      "cat" => CatFileCommand.new(path)
    }
  end
end

DirectoryContext.new(".").push
