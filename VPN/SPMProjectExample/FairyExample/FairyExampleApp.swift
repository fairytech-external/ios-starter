/*
 Fairy Technologies CONFIDENTIAL
 __________________
  
 Copyright (C) Fairy Technologies, Inc - All Rights Reserved
 
 NOTICE:  All information contained herein is, and remains
 the property of Fairy Technologies Incorporated and its suppliers,
 if any.  The intellectual and technical concepts contained
 herein are proprietary to Fairy Technologies Incorporated
 and its suppliers and may be covered by U.S. and Foreign Patents,
 patents in process, and are protected by trade secret or copyright law.
 Dissemination of this information, or reproduction or modification of this material
 is strictly forbidden unless prior written permission is obtained
 from Fairy Technologies Incorporated.
*/

import SwiftUI
import Moment

@main
struct FairyExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        MomentVPNService.initialize(packetTunnelBundleIdentifier: "ai.fairytech.FairyExample.PacketTunnel")
        
        requestNotificationAuthorization()
    }
    
    func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        let userNotificationCenter = UNUserNotificationCenter.current()

        userNotificationCenter.requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Error: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        userNotificationCenter.delegate = self
    }
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let isFromMoment = response.notification.request.content.userInfo[MomentConstants.MOMENT_NOTIFICATION_KEY] as? Bool, isFromMoment{
//            handleMomentNotification(response: response)
        } else {
            // Handle non-Moment notification
        }
        completionHandler()
    }
}
