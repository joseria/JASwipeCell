#
#  Be sure to run `pod spec lint JASwipeCell.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "JASwipeCell"
  s.version      = "1.0.0"
  s.summary      = "A UITableViewCell subclass that simulates IOS 8 mail's swipe cells."

  s.description  = <<-DESC
                   A UITableViewCell subclass that displays customizable left or right buttons that are revealed as the user swipes the cell in either direction. The edge-most buttons will pin to the container view and will execute an event similar to how the delete/archive button work in IOS 8 mail. A great way to simulate IOS 8 mail's behavior.
                   DESC

  s.homepage     = "https://github.com/joseria/JASwipeCell"
  s.license      = 'MIT'
  s.author             = { "Jose Alvarez" => "jose.a.alvarez@gmail.com" }
  s.social_media_url   = "http://twitter.com/joseaalvarez"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/joseria/JASwipeCell.git", :tag => "1.0.0" }
  s.source_files  = 'JASwipeCell'
  s.requires_arc = true
end
