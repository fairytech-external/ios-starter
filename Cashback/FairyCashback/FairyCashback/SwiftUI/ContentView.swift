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
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var cashbackPrograms: [CashbackProgram] = []
    @State private var showCashbackListView = false
    @State private var isShowingUIKitExample = false
    
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
                    
                    Button(action: {
                        MomentCashbackService.setUserId("test_user_id")
                        fetchCashbackPrograms()
                    }) {
                        Text("Show Cashback Programs (SwiftUI)")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    
                    NavigationLink(
                        destination: CashbackListView(cashbackPrograms: cashbackPrograms,
                                                      showCashbackListView: $showCashbackListView),
                        isActive: $showCashbackListView,
                        label: {
                            EmptyView()
                        }
                    )
                    
                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingUIKitExample = true
                    }) {
                        Text("Show Cashback Programs (UIKit)")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $isShowingUIKitExample) {
                        UIKitCashbackListView()
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func fetchCashbackPrograms() {
        isLoading = true
        Task {
            do {
                cashbackPrograms = try await MomentCashbackService.listCashback()
                isLoading = false
                showCashbackListView = true
            } catch {
                alertMessage = error.localizedDescription
                showAlert = true
                isLoading = false
            }
        }
    }
}
