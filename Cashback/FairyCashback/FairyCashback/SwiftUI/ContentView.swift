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

struct ContentView: View {
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isNavigating: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.black, .purple, .white]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Fairy Cashback")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 50)
                    
                    Text("캐시백 프로그램을 확인해보세요!")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    NavigationLink(
                        destination: MomentCashbackService.launchCashbackUI(onFinish: {
                            print("Cashback UI is dismissed.")
                            isNavigating = false
                        })
                            .edgesIgnoringSafeArea(.all)
                            .navigationBarTitle("Cashback Programs", displayMode: .inline)
                            .navigationBarBackButtonHidden(true),
                        isActive: $isNavigating
                    ) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        MomentCashbackService.setUserId("user-id-is-needed")
                        isNavigating = true
                    }) {
                        Text("Show Cashback Programs")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}
