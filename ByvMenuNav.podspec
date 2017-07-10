#
# Be sure to run `pod lib lint ByvMenuNav.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ByvMenuNav'
    s.version          = '1.0.3'
    s.summary          = 'Is an UINavigationController than manage menus.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
Is an UINavigationController than manage menus. It add lft menu button automatically
                       DESC

    s.homepage         = 'https://github.com/byvapps/ByvMenuNav'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Adrian Apodaca' => 'adrian@byvapps.com' }
    s.source           = { :git => 'https://github.com/byvapps/ByvMenuNav.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/byvapps'

    s.ios.deployment_target = '8.0'

    s.source_files = 'ByvMenuNav/Classes/**/*'
    s.requires_arc = true
end
