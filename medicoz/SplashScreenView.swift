//
//  SplashScreenView.swift
//  medicoz
//
//  Created by Sachin Sharma on 19/01/23.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State var isActive: Bool = false
    @State private var size = 0.7
    @State private var opacity = 0.4
    
    @StateObject var sessionManager = SessionManager()
    
    @AppStorage ("uid") var userID: String = ""
    @AppStorage ("userRole") var role: String = ""
    
    var body: some View {
        ZStack{
            if isActive {
                if userID == "" {
                    sessionAuth()
                } else {
                    redirectAuth()
                }
             }
            else {
                ZStack {
                    
                    LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.2), Color.pink.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(alignment: .center) {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 100)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear{
                        withAnimation(.easeIn(duration: 1.0)) {
                            self.size = 1.4
                            self.opacity = 1.0
                        }
                    }
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation{
                                self.isActive = true
                            }
                        }
                    }
                }
            }
        }.transition(.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .bottom)
        ))
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
