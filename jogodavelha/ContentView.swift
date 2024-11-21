//
//  ContentView.swift
//  jogodavelha
//
//  Created by Sandro Lopes on 22/02/24.
//

import SwiftUI

struct ContentView: View {
    
let columns: [GridItem] = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),]

@State private var moves: [Move?] = Array(repeating: nil, count: 9)
@State private var isGameboardDisabled = false
@State private var alertItem : AlertItem?
    @State private var humanPonto = 0
    @State private var computerPonto = 0


    var body: some View {
        ZStack{
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    
                    
                    HStack {
                        Image(systemName: "\(computerPonto).circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.black)
                            .padding(30)
                        
                        Text("Vs")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Image(systemName: "\(humanPonto).circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                            .padding(30)
                    }.padding(50)
                    
                    
                }
                Spacer()
                VStack{
                    Spacer()
                    LazyVGrid(columns: columns, spacing: 5){
                        ForEach(0..<9) {i in
                            ZStack{
                                Circle()
                                    .foregroundColor(.gray).opacity(0.4)
                                    .frame(width: geometry.size.width/3 - 15,
                                           height: geometry.size.width/3 - 15)
                                
                                Image(systemName: moves[i]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.black)
                            }
                            .onTapGesture {
                                if isSquareOccupied(in: moves, forIndex: i) { return }
                                moves[i] = Move(player: .human, boardIndex: i)
                                
                                if checkWinCondition(for: .human, in: moves){
                                    let alertContext = AlertContext()
                                    alertItem = alertContext.humanWin
                                    humanPonto += 1
                                    return
                                }
                                
                                if checkForDraw(in: moves){
                                    let alertContext = AlertContext()
                                    alertItem = alertContext.draw
                                    return
                                }
                                isGameboardDisabled = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    let computerPosition = determineComputerMovePosition(in: moves)
                                    moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                    isGameboardDisabled = false
                                    
                                    if checkWinCondition(for: .computer, in: moves){
                                        let alertContext = AlertContext()
                                        alertItem = alertContext.computerWin
                                        computerPonto += 1
                                        return
                                    }
                                    
                                    if checkForDraw(in: moves){
                                        let alertContext = AlertContext()
                                        alertItem = alertContext.draw
                                        return
                                    }
                                }
                                
                            }
                        }
                    }
                    
                    HStack{
                        HStack {Image("robo")
                                .resizable()
                                .frame(width: 130, height: 170)
                                .foregroundColor(.blue)
                        }
                        .padding(20)
                        HStack{Text("Vs")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding()
                        HStack {Image("auto")
                                .resizable()
                                .frame(width: 120, height: 180)
                                .foregroundColor(.red)
                        }
                    }
                    
                }
                .disabled(isGameboardDisabled)
                .padding()
                .alert(item: $alertItem, content: { alertItem in
                    Alert(title: alertItem.title,
                          message: alertItem.message,
                          dismissButton: .default(alertItem.buttonTitle, action: { resetGame() }))
                    
                    
                })
            }
        }
        .background(
                    Image("universo5")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        //.rotationEffect(Angle(degrees: 180))
                        
                        .edgesIgnoringSafeArea(.all)
                )
           
        
    }
    
        func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
                return moves.contains(where: {$0?.boardIndex == index})
            }
                   
                 
                   func determineComputerMovePosition(in moves: [Move?]) -> Int {
                
                let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
                
                let computerMoves = moves.compactMap{ $0 }.filter { $0.player == .computer}
                let computerPositions = Set(computerMoves.map { $0.boardIndex})
                
                for pattern in winPatterns{
                    let winPositions = pattern.subtracting(computerPositions)
                    
                    if winPositions.count == 1 {
                        let isAvaiable = !isSquareOccupied(in: moves, forIndex:winPositions.first!)
                        if isAvaiable {return winPositions.first!}
                    }
                }
                
                let humanMoves = moves.compactMap{ $0 }.filter  { $0.player == .computer}
                let humanPositions = Set(humanMoves.map { $0.boardIndex})
                
                for pattern in winPatterns{
                    let winPositions = pattern.subtracting(humanPositions)
                    
                    if winPositions.count == 1 {
                        let isAvaiable = !isSquareOccupied(in: moves, forIndex:winPositions.first!)
                        if isAvaiable {return winPositions.first!}
                    }
                }
                let centerSquare = 4
                if !isSquareOccupied(in: moves, forIndex: centerSquare){
                    return centerSquare
                }
                
                
                var movePosition = Int.random(in: 0..<9)
                
                       while isSquareOccupied(in: moves, forIndex: movePosition){
                    movePosition = Int.random(in: 0..<9)
                }
                return movePosition
            }
                   func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
                let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
                
                let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
                let playerPositions = Set(playerMoves.map { $0.boardIndex})
                
                for pattern in winPatterns where pattern.isSubset(of: playerPositions){ return true   }
                return false
            }
                   
                   func checkForDraw(in moves: [Move?]) -> Bool {
                return moves.compactMap { $0 }.count == 9
            }
                   
                   func resetGame(){
                moves = Array(repeating: nil, count: 9)
                       if humanPonto  >= 10 {
                           humanPonto = 0
                           computerPonto = 0
                           let alertContext = AlertContext()
                           alertItem = alertContext.fim
                       }
                       if computerPonto  >= 10 {
                           humanPonto = 0
                           computerPonto = 0
                           let alertContext = AlertContext()
                           alertItem = alertContext.fim
                       }
            }
                   }
                                                     
                   enum Player {
                case human, computer
            }
                 
                   struct Move {
                let player: Player
                let boardIndex: Int
                
                var indicator: String {
                    return player == .human ? "airtag" : "xmark"
                }
            }
                                                     
                                                     
 

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
