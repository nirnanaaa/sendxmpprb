# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sendxmpp/version"

Gem::Specification.new do |s|
  s.name        = "sendxmpp"
  s.version     = Sendxmpp::VERSION
  s.authors     = ["Florian Kasper"]
  s.email       = ["florian.kasper@corscience.de"]
  s.homepage    = "https://github.com/nirnanaaa/sendxmpprb"
  s.summary     = %q{Send messages from the console to a XMPP server}
  s.description = %q{Send messages from the console to a XMPP server}

  s.rubyforge_project = "sendxmpp"
  s.license = "MIT"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_runtime_dependency "thor", "~> 0.19", '>= 0.19.1'
  s.add_runtime_dependency "inifile", "~> 2.0"
  s.add_runtime_dependency "xmpp4r", "~> 0.5"
  s.add_dependency "hashr"

  s.add_development_dependency "rake", "~> 10.1"
end
