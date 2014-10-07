Gem::Specification.new do |s|
  s.name = 'mtlite'
  s.version = '0.2.4'
  s.summary = 'mtlite'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_runtime_dependency('rdiscount', '~> 2.1', '>=2.1.7.1')
  s.signing_key = '../privatekeys/mtlite.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/mtlite'
  s.required_ruby_version = '>= 2.1.0'
end
