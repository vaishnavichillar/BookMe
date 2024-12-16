platform :ios, '15.0'

target 'BookMeNow' do
  use_frameworks!

  # Pods for BookMeNow
  #pod 'DatePickerDialog'
  #pod 'RealTimePicker'
   #pod 'Firebase'
   #pod 'CountryPickerView'
   #pod 'PhoneNumberKit'
   pod 'FSCalendar'
   
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
            end
        end
    end
    
    installer.pods_project.targets.each do |target|
      if ['MaterialCard'].include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5.0'
            end
          end
    end
end

