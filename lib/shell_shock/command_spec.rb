# frozen_string_literal: true

module ShellShock
  module CommandSpec
    def with_usage(text)
      it("should display usage") { @command.usage.should == text }
    end

    def with_help(text)
      it("should display help") { @command.help.should == text }
    end
  end
end
