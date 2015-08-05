Pod::Spec.new do |s|
  s.name     = 'upnpx'
  s.version  = '1.3.4'
  s.license  = 'BSD'
  s.ios.deployment_target = "6.1"
  s.osx.deployment_target = "10.6"
  s.summary  = 'Open Source Mac OS X / iOS Cocoa UPnP Stack.'
  s.homepage = 'https://github.com/fkuehne/upnpx'
  s.authors  = { 'Felix Paul Kühne' => 'fkuehne@videolan.org', 'Bruno Keymolen' => 'bruno.keymolen@gmail.com', 'Paul Williamson' => 'squarefrog@gmail.com' }
  s.source   = { :git  => 'https://github.com/fkuehne/upnpx.git', :tag => s.version.to_s }

  s.description = 'Static OS X & iOS UPnP library written in Cocoa (UPnP) and C++ (SSDP).' \
    'The Current implementation has support for control point/client only.'

  s.ios.source_files =  'src/{api,common,eventserver,ssdp,upnp}/*.{h,m,mm,c,cpp}', 'src/port/ios/*.{h,m}'
  s.osx.source_files =  'src/{api,common,eventserver,ssdp,upnp}/*.{h,m,mm,c,cpp}', 'src/port/macos/*.{h,m}'
  s.ios.public_header_files = 'src/api/*.h', 'src/port/ios/*.h'
  s.osx.public_header_files = 'src/api/*.h', 'src/port/macos/*.h'
  s.library          = 'stdc++'
  s.xcconfig = {
       'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x',
       'CLANG_CXX_LIBRARY' => 'libstdc++',
       'OTHER_LDFLAGS' => '-weak_library /usr/lib/libstdc++.dylib'
  }
  s.requires_arc = false
end
