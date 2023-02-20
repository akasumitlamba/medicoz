
//
//  LoginScreen.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct testui: View {
    
    @State private var cardShow = false
    @State private var cardDismess = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center){
                Spacer()
                HStack{
                    Image("mascot")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 60, height: 60)
                    Text("Medicoz")
                        .bold()
                        .font(.largeTitle)
                }
                
                Text("Start your account setup process")
                    .foregroundColor(.black.opacity(0.7))
                
                
                Spacer()
                
                Button {
                    cardShow = true
                } label: {
                    Text("Get Started")
                }
                .font(.body.weight(.medium))
                .padding(.vertical, 16)
                .frame(width: 320)
                .clipped()
                .foregroundColor(Color(.systemBackground))
                .background {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.primary)
                }
                
            }
        }
    }
}

struct BottomCard<Content: View>: View {
    let content: Content
    @Binding private var cardShow: Bool
    @Binding private var cardDismess: Bool
    
    init(cardShow: Binding<Bool>, cardDismess: Binding<Bool>,
        @ViewBuilder content: () -> Content) {
        _cardShow = cardShow
        _cardDismess = cardDismess
        self.content = content()
    }
    
    var body: some View {
        ZStack{
            Text("Hello")
            //dimmed
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.red.opacity(0.3))
            .opacity(0.3)
            .animation(.easeIn, value: 5)
            
            
            //card
            
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        testui()
    }
}
