lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'neeto_grow_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = 'neeto_grow_ruby'
  spec.version       = NeetoGrowRuby::VERSION
  spec.authors       = ['Unnikrishnan KP', 'Sandip Mane']
  spec.email         = ['unnikrishnan.kp@bigbinary.com', 'sandip.mane@bigbinary.com']

  spec.summary       = 'Ruby wrapper for the neetoGrow API'
  spec.homepage      = 'http://github.com/bigbinary/neeto_grow_ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4'

  spec.add_development_dependency 'bundler', '>= 1.15'
end
