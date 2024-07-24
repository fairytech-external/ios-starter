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
import Combine
import Moment
import NetworkExtension

struct ContentView: View {
    @State private var cancellables: Set<AnyCancellable> = []
    
    @State private var isOn: Bool = false
    @State private var isSpinning: Bool = false
    @State private var statusText: String = ""
    @State private var userInitiatedToggle: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorDescription: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Fairy Moment VPN Example")
                .font(.title)
                .padding()
            
            HStack {
                Spacer()
                    .frame(width: 20)
    
                Text("VPN Status")
                
                Spacer()
                
                if isSpinning {
                    ProgressView()
                }
                
                Text(statusText)
                    .padding()
                
                Toggle(isOn: $isOn) {
                }
                .labelsHidden()
                .onChange(of: isOn) { newValue in
                    userInitiatedToggle = true
                }
                .disabled(self.isSpinning)
                .onReceive(Just(isOn)) { value in
                    if userInitiatedToggle {
                        handleToggleChange(isOn: value)
                    }
                    userInitiatedToggle = false
                }
                Spacer()
                    .frame(width: 20)
            }
            .background(Color.gray.opacity(0.3))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"), message: Text(errorDescription), dismissButton: .default(Text("Dismiss")))
        }
        .onAppear {
            MomentVPNService.shared.setVPNProfileName(to: "CustomedProfileName")
            MomentVPNService.shared.setVPNServerName(to: "CustomedServerName")
            NotificationCenter.default.publisher(for: .NEVPNStatusDidChange)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    updateUIForVPNStatus()
                }
                .store(in: &cancellables)
            
            updateUIForVPNStatus()
        }
    }
    
    func updateUIForVPNStatus() {
        MomentVPNService.shared.withVPNStatus { status in
            if let tunnelStatus = status {
                updateUI(for: tunnelStatus)
            }
        }
    }
    
    func updateUI(for status: NEVPNStatus) {
        switch status {
        case .invalid:
            isOn = false
            isSpinning = false
            statusText = "Invalid"
        case .disconnected:
            isOn = false
            isSpinning = false
            statusText = "Disconnected"
        case .connecting:
            isOn = true
            isSpinning = true
            statusText = "Connecting..."
        case .connected:
            isOn = true
            isSpinning = false
            statusText = "Connected"
        case .reasserting:
            isOn = false
            isSpinning = true
            statusText = "Reasserting..."
        case .disconnecting:
            isOn = false
            isSpinning = true
            statusText = "Disconnecting..."
        @unknown default:
            isOn = false
            isSpinning = false
            statusText = "Unknown"
        }
    }
    
    func handleToggleChange(isOn: Bool) {
        if isOn {
            Task {
                do {
                    try await MomentVPNService.shared.start()
                } catch MomentError.userDeclinedVPNInstallation {
                    self.isOn = false
                    errorDescription = "유저가 VPN 프로필 설치를 거부하였습니다."
                    showErrorAlert = true
                } catch {
                    self.isOn = false
                    print("Error: \(error)")
                    errorDescription = error.localizedDescription
                    showErrorAlert = true
                }
            }
        } else {
            MomentVPNService.shared.stop()
        }
    }
}

#Preview {
    ContentView()
}
