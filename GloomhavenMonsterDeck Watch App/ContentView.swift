//
//  ContentView.swift
//  GloomhavenMonsterDeck Watch App
//
//  Created by Furkan Eken on 16.05.2023.
//

import SwiftUI

struct ContentView: View {
    var width = WKInterfaceDevice.current().screenBounds.width
    @StateObject var deck = Deck()
    
    var body: some View {
        TabView(){
            DeckView(deck: deck)
                .ignoresSafeArea()
                .background(
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                )
                .preferredColorScheme(.light)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            MenuView(deck: deck)
                .ignoresSafeArea()
                .background(Color.black
                )
                .preferredColorScheme(.light)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }.tabViewStyle(PageTabViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
