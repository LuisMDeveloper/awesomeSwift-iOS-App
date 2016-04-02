source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'AwesomeSwift' do
    #pod 'Appz' # External app linking
    #pod 'BluetoothKit' # BluetoothKit
    pod 'CacheManager', :git => 'git@gitlab.com:matteocrippa/cachemanager-lib-ios.git' #, :tag => "0.0.1"
    #pod 'ChameleonFramework' # Color handler
    #pod 'Compass' # App routing
    pod 'Crashlytics' # Crash handler
    #pod 'CryptoSwift' # Cryptography
    #pod 'DGElasticPullToRefresh' # Elastic Pull refresh
    pod 'Dollar' # Underscorejs like
    pod 'Fabric' # Crash handler
    #pod 'FileKit' # File handler
    #pod 'KeychainAccess' # Keychain & TouchID handler
    #pod 'Kingfisher' # Image caching & download
    pod 'Log' # Logging w/ colors
    pod 'Moya' # Networking
    #pod 'MotionKit' # Sensors handler
    pod 'RealmSwift' # Local database
    #pod 'Sorry' # Permission manager
    pod 'SwiftDate' # Data handler
    #pod 'Swifternalization' # Localization
    #pod 'SwiftString' # String handler
    pod 'SwiftyJSON'
    #pod 'SwiftyStoreKit' # InApp purchase
end

def testing_pods
    pod 'Nimble' # BDD
    pod 'Quick' # BDD
    pod 'RealmSwift' # Local database
    pod 'SwiftyJSON'
end

target 'AwesomeSwiftTests' do
    testing_pods
end

target 'AwesomeSwiftUITests' do
    testing_pods
end
