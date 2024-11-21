//
//  Alerta.swift
//  jogodavelha
//
//  Created by Sandro Lopes on 22/02/24.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    let humanWin = AlertItem(title: Text("Você"),
                             message: Text("Foi melhor que IA"),
                             buttonTitle: Text("Jogar"))
    
    let computerWin = AlertItem(title: Text("Vitoria da IA"),
                             message: Text("IA foi melhor que vc .. hahahaha "),
                             buttonTitle: Text("Jogar"))
    
    let draw        = AlertItem(title: Text("Empate"),
                             message: Text("Tente oura vez "),
                             buttonTitle: Text("Jogar"))
    
    let fim        = AlertItem(title: Text("Fim de jogo"),
                             message: Text("Parabens"),
                             buttonTitle: Text("Jogar"))
}

