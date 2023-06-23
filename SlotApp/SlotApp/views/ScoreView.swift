//
//  ScoreView.swift
//  SlotApp
//
//  Created by Bulut Sistem on 23.06.2023.
//

import SwiftUI

struct ScoreView: View {
    var coinsAmount : Int
    var score : Int
    var body: some View {
        HStack {
            HStack{
                Text("Your\nCoins".uppercased())
                    .scoreLabelStyle()
                    .multilineTextAlignment(.trailing)
          
                
                Text("\(coinsAmount)")
                    .scoreNumberStyle()
                    .modifier(ScoreNumberModifier())
            }
            .modifier(ScoreContainerModifier())
            Spacer()
            HStack{
                Text("\(score)")
                    .scoreNumberStyle()
                    .modifier(ScoreNumberModifier())
                
                Text("High\nScore".uppercased())
                    .scoreLabelStyle()
                    .multilineTextAlignment(.leading)
            }
            .modifier(ScoreContainerModifier())
        }
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(coinsAmount: 100,score: 100)
    }
}
