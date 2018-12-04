Gem::Specification.new do |s|
  s.name              = "verifiable_view"
  s.version           = "0.0.1"
  s.summary           = "Database Views that don't break"
  s.description       = "Easier way to mantain Database Views with ActiveRecord"
  s.authors           = ["CarlosIPe"]
  s.email             = ["carlos2@compendium.com.ar"]
  s.homepage          = "https://github.com/carlosipe/verifiable_view"
  s.license           = "MIT"

  s.files = `git ls-files`.split("\n")

  s.add_development_dependency "cutest", '~> 1'
end
