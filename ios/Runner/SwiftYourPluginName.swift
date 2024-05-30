// SwiftYourPluginName.swift

import Flutter
import UIKit
import CallKit

public class SwiftYourPluginName: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "your_plugin_name", binaryMessenger: registrar.messenger())
        let instance = SwiftYourPluginName()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getCallLogDetails" {
            getCallLogDetails(result: result)
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    private func getCallLogDetails(result: FlutterResult) {
        // Fetch call log details using CallKit
        let callManager = CXCallDirectoryManager.sharedInstance
        callManager.reloadExtension(withIdentifier: "your_extension_bundle_identifier") { error in
            if let error = error {
                print("Error reloading extension: \(error.localizedDescription)")
                result(FlutterError(code: "CALL_LOG_ERROR", message: error.localizedDescription, details: nil))
            } else {
                // Get call log details
                let callLogs = callManager.callDirectoryEntries.compactMap { $0 }
                // Process callLogs as needed
                result(callLogs)
            }
        }
    }
}
