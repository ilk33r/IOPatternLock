Pod::Spec.new do |s|

	s.name = 'IOPatternLock'
	s.summary = 'An easy-to-use, customizable Android Pattern Lock view for iOS'
	s.version = '1.0.0'
	s.author = 'Ilker OZCAN'
	s.homepage = 'http://www.ilkerozcan.com.tr'
	s.license = { :type => 'MIT' }

	s.platform = :ios, '9.0'
	s.requires_arc = true
	s.source = { :git => 'https://github.com/ilk33r/IOPatternLock', :tag => '1.0.0' }

	s.ios.deployment_target = '9.0'
	s.default_subspecs = 'Default'
	s.module_name = 'IOPatternLock'
	s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

	s.frameworks = 'Foundation', 'UIKit'

	s.subspec 'Default' do |ss|
		ss.public_header_files = [ 'IOPatternLock/IOPatternLock.h',
									'IOPatternLock/Protocols/IOPatternLockDelegate.h',
									'IOPatternLock/Views/IOPatternLockView.h' ]
		ss.source_files = 'IOPatternLock/**/*.{h,m}'

	end

end
