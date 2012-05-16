spec = Gem::Specification.new do |s|
  s.name = 'mogli'
  s.version = '0.0.37'
  s.summary = 'Open Graph Library for Ruby'
  s.description = 'Simple library for accessing the Facebook Open Graph API'
  s.files = Dir['lib/**/*.rb']
  s.test_files = Dir['spec/**/*.rb']
  s.require_path = 'lib'
  s.author = 'Mike Mangino'
  s.email = 'mmangino@elevatedrails.com'
  s.homepage = 'http://developers.facebook.com/docs/api'
  s.add_dependency 'hashie', '>= 1.1.0'
  s.add_dependency 'httmultiparty', '>= 0.3.6'
  s.add_dependency 'httparty', '>= 0.4.3'
  s.add_dependency 'multi_json', '>= 1.0.3', '< 1.4'
  s.add_development_dependency 'json'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
