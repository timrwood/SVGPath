Pod::Spec.new do |s|
  s.name = "SVGPath"
  s.version = "0.0.1"
  s.summary = "A Swift Library for parsing SVG path strings into UIBezierPaths"

  s.homepage = "https://github.com/timrwood/SVGPath"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "Tim Wood" => "timwoodcreates@gmail.com" }
  s.social_media_url = "http://twitter.com/timtamiam"

  s.platform = :ios

  s.source = { :git => "https://github.com/timrwood/SVGPath.git", :tag => "0.0.1" }

  s.source_files = "SVGPath"
  s.requires_arc = true

  s.framework = "CoreGraphics"
end
