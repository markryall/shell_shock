# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "shell_shock"
  spec.version = "0.0.6"
  spec.summary = "library for creating simple shell applications using readline"
  spec.description = <<~DESCRIPTION
    This is just some code extracted from a few command line gems i've created (shh and cardigan).

    I wanted to move the shared functionality (related to creating a shell with readline) to a seperate gem.'
  DESCRIPTION

  spec.authors << "Mark Ryall"
  spec.email = "mark@ryall.name"
  spec.homepage = "http://github.com/markryall/shell_shock"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.0")

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
