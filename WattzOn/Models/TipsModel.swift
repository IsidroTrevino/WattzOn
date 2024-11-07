//
//  TipsModel.swift
//  WattzOn
//
//  Created by Debanhi Medina on 07/11/24.
//


import Foundation
import SwiftUICore

struct TipsModel: Identifiable, Equatable, Hashable{
    var id = UUID()
    var tipName : String
    var description : String
    var estrategia1 : String
    var textEs1 : String
    var estrategia2 : String
    var textEs2 : String
    var estrategia3 : String
    var textEs3 : String
    var estrategia4 : String
    var textEs4 : String
    var estrategia5 : String
    var textEs5 : String
    var color : Color
}

extension TipsModel{
    public static var defaultTip = TipsModel(tipName: "¿Cómo reducir el consumo eléctrico?", description: "Reducir el consumo eléctrico es una excelente forma de ahorrar dinero y cuidar el medio ambiente. Aquí tienes algunas estrategias efectivas:", estrategia1: "Uso eficiente de la iluminación:", textEs1: "Cambia a bombillas LED: Son más eficientes y duran más que las incandescentes, Apaga las luces: Cuando salgas de una habitación, asegúrate de apagar las luces.", estrategia2: "Electrodomésticos eficientes:", textEs2: "Selecciona electrodomésticos con etiqueta de eficiencia energética: Busca los que tengan la calificación A+ o superior, Desenchufa dispositivos no utilizados: Muchos aparatos consumen energía incluso en modo de espera.", estrategia3: "Calefacción y refrigeración:", textEs3: "Ajusta el termostato: En invierno, mantenlo a 20°C y en verano a 24-26°C, Usa ventiladores: Son más eficientes que el aire acondicionado.", estrategia4: "Uso consciente de agua caliente:", textEs4: "Reduce la temperatura del calentador de agua: Mantén la temperatura a 50°C,Usa duchas en lugar de baños: Las duchas suelen consumir menos agua caliente.", estrategia5: "Cocina de manera eficiente:", textEs5: "Usa tapas en las ollas: Cocinar con tapas reduce el tiempo y la energía, Utiliza microondas y ollas de presión: Son más eficientes que usar la estufa.", color: .yellow)
}

