//
//  MenuView.swift
//  GloomhavenMonsterDeck Watch App
//
//  Created by Furkan Eken on 17.05.2023.
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var deck: Deck
    var width = WKInterfaceDevice.current().screenBounds.width
    
    var body: some View {
        List{
            Group{
                Button{
                    deck.addBless()
                } label: {
                    HStack{
                        Text("Add Bless").foregroundColor(Color.primary)
                        Image("blessP")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width / 7)
                        Text("(\(String(deck.blessCount)))").foregroundColor(Color.primary)
                    }
                }
                Button{
                    deck.addCurse()
                } label: {
                    HStack{
                        Text("Add Curse").foregroundColor(Color.primary)
                        Image("curseP")
                            .resizable()
                            .scaledToFit()
                            .frame(width: width / 7)
                        Text("(\(String(deck.curseCount)))").foregroundColor(Color.primary)
                    }
                }
                
                Button{
                    deck.undo()
                } label: {
                    Text("Undo").foregroundColor(Color.red)
                }
                
                Button{
                    deck.deckReset()
                } label: {
                    Text("Reset Decks")
                        .foregroundColor(Color.red)
                }
                
                Button{
                    deck.shuffleUndrawn()
                } label: {
                    Text("Shuffle Undrawn").foregroundColor(Color.red)
                }
            }
        }
        .listStyle(.carousel)
        .padding(10)
        .cornerRadius(10)
        .font(.body)
        .bold()
    }
}


