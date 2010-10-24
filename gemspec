Gem::Specification.new do |spec|
  spec.name = 'shell_shock'
  spec.version = '0.0.4'
  spec.summary = "library for creating simple shell applications using readline"
  spec.description = <<-EOF
This is just some code extracted from a few command line gems i've created (shh and cardigan).

I wanted to move the shared functionality (related to creating a shell with readline) to a seperate gem.'
EOF

  spec.authors << 'Mark Ryall'
  spec.email = 'mark@ryall.name'
  spec.homepage = 'http://github.com/markryall/shell_shock'
 
  spec.files = Dir['lib/**/*'] + ['README.rdoc', 'MIT-LICENSE']

  spec.add_development_dependency 'rake', '~>0.8.7'
  spec.add_development_dependency 'gemesis', '~>0.0.4'
  spec.add_development_dependency 'rspec', '~>2.0.1'
end
