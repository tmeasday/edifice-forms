$:.push File.expand_path("../lib", __FILE__)
require "edifice-forms/version"

Gem::Specification.new do |s|
  s.name    = 'edifice-forms'
  s.version = Edifice::Forms::VERSION
  s.platform = Gem::Platform::RUBY
  s.author  = 'Tom Coleman'
  s.email   = 'tom@percolatestudio.com'
  s.summary = 'Unobtrusive Rails JS Form extensions'
  s.description = 'Edifice-widgets is a companion gem to edifice which improves and simplifies your experience writing forms for rails.'

  s.add_dependency 'jquery-rails'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
end