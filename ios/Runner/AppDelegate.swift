
import UIKit
import Flutter
import Contacts
import CallKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

   let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "call_log_channel", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if call.method == "getCallLog" {
                var callLogData: [[String: Any]] = []

//                let contact = CNMutableContact()
                let store = CNContactStore()

                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                           let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

                           do {
                               try store.enumerateContacts(with: request) { contact, stop in
                                   // Process the contact
                                   let firstName = contact.givenName
                                   let lastName = contact.familyName
                                   let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
                                   let contactInfo: [String: Any] = [
                                                               "firstName": firstName,
                                                               "lastName": lastName,
                                                               "phoneNumbers": phoneNumbers
                                                           ]
                                   print("Name: \(firstName) \(lastName)")
                                                           print("Phone Numbers: \(phoneNumbers)")
                                        callLogData.append(contactInfo)


                               }
                               result(callLogData)

                           } catch {
                               print("Error fetching contacts: \(error.localizedDescription)")
                               result(error)

                           }

                //let temp = contact.departmentName
               // let callLogData: [String: Any] = [:] // Your call log data
            } else {
                result(FlutterMethodNotImplemented)
            }
        })

      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
