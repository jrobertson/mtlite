Gem::Specification.new do |s|
  s.name = 'mtlite'
  s.version = '0.3.3'
  s.summary = 'mtlite'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('rdiscount', '~> 2.1', '>=2.1.7.1')
  s.add_runtime_dependency('embiggen', '~> 0.1', '>=0.1.0')
  s.signing_key = '../privatekeys/mtlite.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/mtlite'
  s.required_ruby_version = '>= 2.1.0'
end
