Gem::Specification.new do |s|
  s.name        = 'rack-frogger'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Tom Maguire']
  s.email       = ['tom.d.maguire@gmail.com']
  s.summary     = 'Frogger (filtered request logger) is a rack middleware to log HTTP requests filtered by response status and/or uri path'
  s.description = ""
  s.homepage    = 'http://github.com/tomglue/rack-frogger'

  s.files         = `git ls-files`.split("\n") - ['Gemfile.lock']
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rack'
end
