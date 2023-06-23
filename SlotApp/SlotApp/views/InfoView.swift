//
//  InfoView.swift
//  SlotApp
//
//  Created by Bulut Sistem on 23.06.2023.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack(alignment: .center, spacing: 10){
            LogoView()
            
            Spacer()
            
            Form {
                Section(header: Text("Uygulama Hakkında")) {
                    FormView(firstText: "Uygulama", secondText: "Slot Makinesi")
                    FormView(firstText: "Platform", secondText: "Iphone")
                    FormView(firstText: "Version", secondText: "v1.0")
                }
            }
            .font(.system(.body,design: .rounded))
        }
        .padding(.top,40)
        .overlay(
            Button(action: {
                audioPlayer?.stop()
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "xmark.circle")
                    .font(.title)
            }
                .padding(.top,30)
                .padding(.trailing,20)
                .foregroundColor(.gray)
            ,
            alignment: .topTrailing
        )
        .onAppear(perform: {
            playSound(sound: "background-music", type: "mp3")
        })
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}

struct FormView : View {
    var firstText : String
    var secondText : String
    var body : some View {
        HStack{
            Text(firstText).foregroundColor(.gray)
            Spacer()
            Text(secondText)
        }
    }
}
