Gem::Specification.new do |s|
  s.name = 'mtlite'
  s.version = '0.1.0'
  s.summary = 'mtlite'
  s.authors = ['James Robertson']
  s.files = Dir['lib/**/*.rb']
  s.add_dependency('markdown')
  s.signing_key = '../privatekeys/mtlite.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/mtlite'
end
