$: << File.dirname(__FILE__)+'/../lib'

require 'shell_shock/context'

class MoveCommand
  attr_reader :usage, :help

  def initialize room
    @room = room
    @usage = '<direction>'
    @help = 'moves to the adjoining room in the specified direction'
  end

  def completion text
    @room.connections.keys.grep(/^#{text}/).sort
  end

  def execute direction
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

  def initialize room
    puts room.description
    @prompt = "#{room.name} > "
    add_command MoveCommand.new(room), 'go'
  end
end

class Room
  attr_reader :name, :description, :connections
  def initialize name, description
    @name, @description = name, description
    @connections = {}
  end

  def add direction, room
    @connections[direction] = room
  end
end

START = Room.new 'clearing', <<EOF
You have entered a clearing.

A dead goat lies on the ground in front of you
EOF

CAVE_ENTRANCE = Room.new 'cave entrance', <<EOF
You have arrived at the entrance to a cave.

A foul smell is emitting from the cave. Some smoke
can be seen off off to the east.
EOF

CAMP_SITE = Room.new 'camp site', <<EOF
You have arrived in a camp site.

There is a fire that has been recently put out.
EOF

CAVE = Room.new 'cave', <<EOF
You have entered a dark cave.

A faint growling sound can be heard.
EOF

START.add 'north', CAVE_ENTRANCE
CAVE_ENTRANCE.add 'east', CAMP_SITE
CAVE_ENTRANCE.add 'north', CAVE

AdventureContext.new(START).push