//
//  ContentView.swift
//  SlotApp
//
//  Created by Bulut Sistem on 23.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var showingInfoView : Bool = false
    let symbols = ["gfx-bell","gfx-cherry","gfx-coin","gfx-grape","gfx-seven","gfx-strawberry"]
    @State private var reels : Array = [0,1,2]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highScore : Int = UserDefaults.standard.integer(forKey: "highscore")
    @State private var coins : Int = 100
    @State private var betAmount : Int = 10
    @State private var showingModal : Bool = false
    @State private var animatingSymbol : Bool = false
    @State private var animatingModal : Bool = false
    
    func spinReels() {
//        reels[0] = Int.random(in: 0...symbols.count - 1)
//        reels[1] = Int.random(in: 0...symbols.count - 1)
//        reels[2] = Int.random(in: 0...symbols.count - 1)
        
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1 )
        })
        playSound(sound: "spin", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    
    func checkWinning () {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2] {
            playerWins()
            if coins > highScore {
                newHighScore()
            }else{
                playSound(sound: "win", type: "mp3")
            }
        }else{
            playerLose()
        }
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    func newHighScore(){
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "highscore")
        playSound(sound: "high-score", type: "mp3")
    }
    func playerLose(){
        coins -= betAmount
    }
    func activateBet20(){
        betAmount = 20
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)
    }
    func activateBet10(){
        betAmount = 10
        playSound(sound: "casino-chips", type: "mp3")
        haptics.notificationOccurred(.success)

    }
    func isGameOver(){
        if coins <= 0 {
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "highscore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")

    }
    var body: some View {
        ZStack {
            
            //MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"),Color("ColorPurple"),]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center, spacing: 5){
                
                //MARK: - HEADER
                LogoView()
                Spacer()
                //MARK: - SCORE
                ScoreView(coinsAmount: coins, score: highScore)

                //MARK: - SLOT
                VStack(alignment: .center, spacing: 0){
                    ZStack{
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y:animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animatingSymbol.toggle()
                            })
                    }
                    HStack(alignment: .center,spacing: 0) {
                        ZStack{
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y:animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                })
                        }
                        Spacer()
                        ZStack{
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y:animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear(perform: {
                                    self.animatingSymbol.toggle()
                                    playSound(sound: "riseup", type: "mp3")
                                })
                        }
                    }
                    .frame(maxWidth: 500)
                    
                    Button(action: {
                        withAnimation{
                            self.animatingSymbol = false
                        }
                        self.spinReels()
                        withAnimation{
                            self.animatingSymbol = true
                        }
                        self.checkWinning()
                        self.isGameOver()
                       
                    }){
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImageModifier())
                        
                    }
                }
                .layoutPriority(2)
                //MARK: - FOOTER
                Spacer()
                
                HStack{
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.activateBet20()
                        }){
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(betAmount == 20 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                            
                        }
                        .modifier(BetCapsuleModifier())

                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: betAmount == 20 ? 0 : 20)
                            .opacity(betAmount == 20 ? 1 : 0)
                            .modifier(CasinoChipsModifier())
                           
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 10) {
                        
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(betAmount == 10 ? 1 : 0)
                            .offset(x: betAmount == 10 ? 0 : -20)
                            .modifier(CasinoChipsModifier())
                        
                        Button(action: {
                            self.activateBet10()
                        }){
                            
                            Text("10")
                                .fontWeight(.heavy)
                            
                                .foregroundColor(betAmount == 10 ? Color("ColorYellow") : .white)
                                .modifier(BetNumberModifier())
                            
                        }
                        .modifier(BetCapsuleModifier())

                           
                    }
                }
                
            }
            .overlay(
                Button(action: {
                    self.resetGame()
                }){
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                Button(action: {
                    print("Info")
                    self.showingInfoView = true
                }){
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0,opaque: false)
            
            if $showingModal.wrappedValue {
                ZStack{
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    VStack(spacing: 0){
                        
                        Text("Game Over")
                            .font(.system(.title,design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0,maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(.white)
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16){
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 72)
                            Text("Bütün coinlerinizi kaybettiniz.\nTekrardan deneyin")
                            .font(.system(.body,design: .rounded))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .layoutPriority(1)
                            
                            Button(action: {
                                self.showingModal = false
                                self.coins = 100
                                self.animatingModal = false
                                self.activateBet10()
                            }){
                                Text("Yeni Oyun".uppercased())
                                    .font(.system(.body,design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal,12)
                                    .padding(.vertical,8)
                                    .frame(minWidth: 128)
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                        }
                        Spacer()
                    }.frame(minWidth: 280,idealWidth: 280,maxWidth: 320,minHeight: 260,idealHeight: 280,maxHeight: 320,alignment: .center)
                        .background(.white)
                        .cornerRadius(20)
                        .shadow(color: Color("ColorTransparentBlack"), radius: 6,x: 0,y: 8)
                        .opacity($animatingModal.wrappedValue ? 1 : 0)
                        .offset(y:$animatingModal.wrappedValue ? 0 : -100)
                        .animation(Animation.spring(response: 0.6,dampingFraction: 1.0,blendDuration: 1.0))
                        .onAppear(perform: {
                            self.animatingModal = true
                        })
                    
                    
                }
            }
            
        }
        .sheet(isPresented: $showingInfoView, content: {
            InfoView()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
