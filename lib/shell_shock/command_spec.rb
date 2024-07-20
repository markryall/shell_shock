# frozen_string_literal: true

module ShellShock
  module CommandSpec
    def with_usage(text)
      it("displays usage") { expect(@command.usage).to eq(text) }
    end

    def with_help(text)
      it("displays help") { expect(@command.help).to eq(text) }
    end
  end
end
