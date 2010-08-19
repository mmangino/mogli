spec = Gem::Specification.new do |s|
  s.name = 'mogli'
  s.version = '0.0.13'
  s.summary = "Open Graph Library for Ruby"
  s.description = %{Simple library for accessing the facebook Open Graph API}
  s.files = Dir['lib/**/*.rb']
  s.require_path = 'lib'
  s.has_rdoc = false
  s.author = "Mike Mangino"
  s.email = "mmangino@elevatedrails.com"
  s.homepage = "http://developers.facebook.com/docs/api"
  s.add_dependency('hashie', ">=0.2.0")
  s.add_dependency('httparty', ">=0.4.3")
end
