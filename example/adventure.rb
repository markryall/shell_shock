# frozen_string_literal: true

$LOAD_PATH << "#{File.dirname(__FILE__)}/../lib"

require "shell_shock/context"

class MoveCommand
  attr_reader :usage, :help

  def initialize(room)
    @room = room
    @usage = "<direction>"
    @help = "moves to the adjoining room in the specified direction"
  end

  def completion(text)
    @room.connections.keys.grep(/^#{text}/).sort
  end

  def execute(direction)
    room = @room.connections[direction]
    if room
      AdventureContext.new(room).push
    else
      puts "there is no adjoining room to the #{direction}"
    end
  end
end

class AdventureContext
  include ShellShock::Context

  def initialize(room)
    puts room.description
    @prompt = "#{room.name} > "
    add_command MoveCommand.new(room), "go"
  end
end

class Room
  attr_reader :name, :description, :connections

  def initialize(name, description)
    @name = name
    @description = description
    @connections = {}
  end

  def add(direction, room)
    @connections[direction] = room
  end
end

START = Room.new "clearing", <<~DESCRIPTION
  You have entered a clearing.

  A dead goat lies on the ground in front of you
DESCRIPTION

CAVE_ENTRANCE = Room.new "cave entrance", <<~DESCRIPTION
  You have arrived at the entrance to a cave.

  A foul smell is emitting from the cave. Some smoke
  can be seen off off to the east.
DESCRIPTION

CAMP_SITE = Room.new "camp site", <<~DESCRIPTION
  You have arrived in a camp site.

  There is a fire that has been recently put out.
DESCRIPTION

CAVE = Room.new "cave", <<~DESCRIPTION
  You have entered a dark cave.

  A faint growling sound can be heard.
DESCRIPTION

START.add "north", CAVE_ENTRANCE
CAVE_ENTRANCE.add "east", CAMP_SITE
CAVE_ENTRANCE.add "north", CAVE

AdventureContext.new(START).push
