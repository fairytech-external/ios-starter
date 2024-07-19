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

import Moment
import UIKit

class PacketTunnelProvider: Moment.PacketTunnelProvider {
    override init() {
        super.init()
        self.antiPhishingDelegate = AntiPhishingDetectionDelegate()
    }
}

class AntiPhishingDetectionDelegate: Moment.AntiPhishingDelegate {
    func handleAntiPhishingDetection(domain: String) async {
        let notificationContent = UNMutableNotificationContent()

        notificationContent.title = "Fairy AntiPhishing Example"
        notificationContent.body = "\(domain)은 피싱 위험이 있습니다!"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Notification Error: ", error)
        }
    }
}
