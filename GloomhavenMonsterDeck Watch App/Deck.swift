//
//  Deck.swift
//  GloomhavenMonsterDeck Watch App
//
//  Created by Furkan Eken on 16.05.2023.
//
import SwiftUI
import Foundation

class Card: Identifiable, Codable {
    var cardID = UUID()
    var cardName = "zero"
    var cardAngle = 0.0
    var cardOffset = 0
    var cardImage = "back"
    
}

final class Deck: ObservableObject {
    @Published private(set) var cards: [Card]
    private let animationSpeed : Double = 0.6
    let id = UUID()
    var buttonArray = [Bool]()
    
    var isShuffle = false
    var discardCount = 0
    
    var back = "back"
    private let cardHeight = WKInterfaceDevice.current().screenBounds.width * 0.75 * 0.65
    
    var curseCount = 0
    var blessCount = 0
    
    private enum CodingKeys: String, CodingKey {
        case cards
        case animationSpeed
        case id
        case buttonArray
        
        case isShuffle
        case discardCount
        
        case back
        case cardHeight
        case curseCount
        case blessCount
    }
   
    
    init() {
        cards = getCardListByNumber()
        
        for _ in 0...14 {
            buttonArray.append(false)
        }
        
        func createCard(name: CardNames) -> Card {
            let card = Card()
            card.cardName = name.rawValue
            return card
        }

        func getCardListByNumber() -> [Card] {
            let allNames = CardNames.allCases
            var cardArray = [Card]()

            allNames.forEach { type in
                let loopCount = type.defaultDeck()

                for _ in 0..<loopCount {
                    cardArray.append(createCard(name: type))
                }
            }
            return cardArray.shuffled()
        }
    }
    
    func deckShuffle() {
        cards.removeAll {
            ($0.cardName == "bless" || $0.cardName == "curse") && $0.cardOffset != 0
        }
        
        cardBackAnim()
        
        discardCount = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed * 1.75) {
            
            self.cards.shuffle()
        }
    }
    
    func cardBackAnim() {
        if !cards.isEmpty {
            withAnimation(.linear(duration: animationSpeed)) {
                objectWillChange.send()
                for flippedCard in cards {
                    if flippedCard.cardOffset != 0 {
                        flippedCard.cardAngle = 0
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed / 2) {
                for flippedCard in self.cards {
                    self.objectWillChange.send()
                    flippedCard.cardImage = self.back
                }
            }
            
            withAnimation(.linear(duration: animationSpeed * 0.75).delay(animationSpeed)) {
                objectWillChange.send()
                for flippedCard in self.cards {
                    flippedCard.cardOffset = 0
                }
            }
        }
    }
    
    func cardAnim(_ card: Card) {
        withAnimation(.linear(duration: animationSpeed))
        {
                objectWillChange.send()
                card.cardAngle = 180
                card.cardOffset = 5

                for flippedCard in cards {
                    if flippedCard.cardOffset != 0 {
                        flippedCard.cardOffset += Int(cardHeight * 1.02)
                    }
                }
            }
        DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed / 2) {
            self.objectWillChange.send()
            card.cardImage = card.cardName
        }
        discardCount += 1
    }
    
    func shuffleUndrawn(){
        cards.shuffle()
    }
    
    func enableShuffle(_ kart: Card) -> Bool{
        if kart.cardName == "miss" || kart.cardName == "crit" {
            return true
        }
        return false
    }
    
    func undo(){
        for kart in cards where kart.cardOffset != 0 {
            if kart.cardOffset == (60 + Int(cardHeight * 1.03)) {
//                isShuffle = !enableShuffle(kart)
                withAnimation(.linear(duration: animationSpeed)) {
                    objectWillChange.send()
                            kart.cardAngle = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed / 2) {
                        self.objectWillChange.send()
                        kart.cardImage = self.back
                }
                withAnimation(.linear(duration: animationSpeed * 0.75).delay(animationSpeed)) {
                    objectWillChange.send()
                        kart.cardOffset = 0
                }
            } else {
                withAnimation(.linear(duration: animationSpeed).delay(animationSpeed)) {
                    objectWillChange.send()
                    kart.cardOffset -= Int(cardHeight * 1.03)
                }
            }
        }
        var dummy = false
        for kart in cards where kart.cardAngle != 0 {
            if enableShuffle(kart) {
                dummy = true
                continue
            }
        }
        isShuffle = dummy ? true : false
        if discardCount > 0 {
            discardCount -= 1
        }
        
    }
    
    func addCurse() {
        let curse = Card()
        curse.cardName = "curse"
        
        cards.append(curse)
        curseCount += 1
        shuffleUndrawn()
    }
    
    func addBless() {
        let bless = Card()
        bless.cardName = "bless"
        
        cards.append(bless)
        blessCount += 1
        shuffleUndrawn()
    }
    
    func blessCurseCheck(_ kart: Card) {
        if kart.cardName == "bless" {
            blessCount -= 1
        }
        if kart.cardName == "curse" {
            curseCount -= 1
        }
    }
    
    func deckReset() {
        deckShuffle()
        cards.removeAll {
            $0.cardName == "bless" || $0.cardName == "curse" || $0.cardName == "minusOneScenario"
        }
        blessCount = 0
        curseCount = 0
        isShuffle = false
    }
    
    func removeCard(cardName: String, count: Int = 1){
        for _ in 0..<count {
            if let index = cards.firstIndex(where: {$0.cardName == cardName}) {
                cards.remove(at: index)
            }
        }
    }
    
    func refresh() {
        objectWillChange.send()
    }
    
    enum CardNames: String, CaseIterable {
        case zero
        case minusOne
        case minusTwo
        case plusOne
        case plusTwo
        case miss
        case crit

        func defaultDeck() -> Int {
            switch self {
                case .zero:
                    return 6
                case .minusOne, .plusOne:
                    return 5
                case .minusTwo, .plusTwo, .miss, .crit:
                    return 1
            }
        }
    }
}
