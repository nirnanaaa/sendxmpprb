# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sendxmpp/version"

Gem::Specification.new do |s|
  s.name        = "sendxmpp"
  s.version     = Sendxmpp::VERSION
  s.authors     = ["Florian Kasper"]
  s.email       = ["florian.kasper@corscience.de"]
  s.homepage    = "http://git.er.corscience.de"
  s.summary     = %q{TODO Update Summary}
  s.description = %q{TODO Update Description}

  s.rubyforge_project = "none"
  s.license = "PROPRIETARY"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_runtime_dependency "thor", "~> 0.19", '>= 0.19.1'
  s.add_runtime_dependency "net-ssh", "~> 2.9"
  s.add_runtime_dependency "net-scp", "~> 1.1"
  s.add_runtime_dependency "json", "~> 1.8"
  s.add_runtime_dependency "inifile", "~> 2.0"

  s.add_development_dependency "rake", "~> 10.1"
end
