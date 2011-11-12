# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "keysms/version"

Gem::Specification.new do |s|
  s.name        = "keysms"
  s.version     = Keysms::VERSION
  s.authors     = ["Ricco Førgaard"]
  s.email       = ["ricco@fiskeben.dk"]
  s.homepage    = "http://fiskeben.dk/keysms"
  s.summary     = %q{Send text messages to mobile phones using the KeySMS gateway.}
  s.description = %q{This gem wraps the API for the SMS gateway KeySMS run by the Norwegian company Keyteq. For more info, see http://keysms.no}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec"
  s.add_dependency "json"
  s.add_dependency "patron"
end
