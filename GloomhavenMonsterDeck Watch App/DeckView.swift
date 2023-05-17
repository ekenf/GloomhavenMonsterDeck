//
//  DeckView.swift
//  GloomhavenMonsterDeck Watch App
//
//  Created by Furkan Eken on 16.05.2023.
//

import SwiftUI

struct DeckView: View {
    @ObservedObject var deck : Deck
    
    let cardWidth = WKInterfaceDevice.current().screenBounds.width * 0.75
    let cardHeight = WKInterfaceDevice.current().screenBounds.width * 0.75 * 0.65
    
    var body: some View {
            ScrollView(showsIndicators: false) {
                VStack {
                    HStack{
                        Text("\(deck.cards.count - deck.discardCount)")
                            .animation(nil)
                            .frame(width: cardWidth / 6.5)
                            .padding(.leading, 10)
                            .lineLimit(1)
                            .font(.footnote)
                        
                        Spacer()
                        
                        Button {
                            deck.deckShuffle()
                            deck.isShuffle = false
                        } label: {
                                Image(systemName: "arrow.clockwise.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.black.opacity(deck.isShuffle ? 0.8 : 0.2))
                                    .background(Color(red: 246 / 255, green: 223 / 255, blue: 201 / 255).opacity(deck.isShuffle ? 0.7 : 0))
                                    .clipShape(Circle())
                                    .padding(3)
                        }
                        .buttonStyle(.borderless)
                        .disabled(!deck.isShuffle)
                        .frame(width: cardWidth * 0.2)
                        
                        Spacer()
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: cardWidth / 6.5)
                            .padding(.trailing, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 2)
                    
                    ZStack {
                        ForEach(deck.cards, id: \.cardID) { card in
                            Image(card.cardImage)
                                .resizable()
                                .cornerRadius(10)
                                .frame(width: cardWidth, height: cardHeight)
                                .rotation3DEffect(.degrees(card.cardAngle), axis: (x: 1, y: 0, z: 0))
                                .offset(y: CGFloat(card.cardOffset))
                                .onTapGesture {
                                    print(card.cardName)
                                    deck.cardAnim(card)
                                    deck.isShuffle = deck.isShuffle ? true : deck.enableShuffle(card)
                                    deck.blessCurseCheck(card)
                                    //AppDelegate.decks = decks
                                }
                                .allowsHitTesting(card.cardOffset == 0)
                                .frame(width: cardWidth * 1.33)
                        }
                    }
                    Spacer()
                    ForEach(0..<deck.discardCount, id: \.self) { _ in
                        Rectangle()
                            .frame(width: cardWidth, height: cardHeight + 5)
                            .opacity(0)
                    }
                }
            }
    }
}

