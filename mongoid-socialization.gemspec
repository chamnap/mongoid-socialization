# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/socialization/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid-socialization"
  spec.version       = Mongoid::Socialization::VERSION
  spec.authors       = ["Chamnap Chhorn"]
  spec.email         = ["chamnapchhorn@gmail.com"]
  spec.summary       = %q{Socialize your app with Likes, Follows, WishLists, Mentions, and Private Messages}
  spec.description   = %q{Socialization allows any models to Like, Follow, WishList, Mention, and Message any other models.}
  spec.homepage      = "https://github.com/chamnap/mongoid-socialization"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mongoid", ">= 3.1.6"
  spec.add_dependency "mongoid-observers", "~> 0.1.1"
end