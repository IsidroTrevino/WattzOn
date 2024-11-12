//
//  TipsViewModel.swift
//  WattzOn
//
//  Created by Debanhi Medina on 07/11/24.
//


import Foundation
import SwiftUI

@Observable
class TipsViewModel{
    
    var arrTip = [TipsModel]()
    
    init(){
        getTips()
    }
    
    func getTips(){
        var tip : TipsModel
        
        tip = TipsModel(tipName: "¿Cómo reducir el consumo eléctrico?", description: "Reducir el consumo eléctrico es una excelente forma de ahorrar dinero y cuidar el medio ambiente. Aquí tienes algunas estrategias efectivas:", estrategia1: "Uso eficiente de la iluminación:", textEs1: "Cambia a bombillas LED: Son más eficientes y duran más que las incandescentes, Apaga las luces: Cuando salgas de una habitación, asegúrate de apagar las luces.", estrategia2: "Electrodomésticos eficientes:", textEs2: "Selecciona electrodomésticos con etiqueta de eficiencia energética: Busca los que tengan la calificación A+ o superior, Desenchufa dispositivos no utilizados: Muchos aparatos consumen energía incluso en modo de espera.", estrategia3: "Calefacción y refrigeración:", textEs3: "Ajusta el termostato: En invierno, mantenlo a 20°C y en verano a 24-26°C, Usa ventiladores: Son más eficientes que el aire acondicionado.", estrategia4: "Uso consciente de agua caliente:", textEs4: "Reduce la temperatura del calentador de agua: Mantén la temperatura a 50°C,Usa duchas en lugar de baños: Las duchas suelen consumir menos agua caliente.", estrategia5: "Cocina de manera eficiente:", textEs5: "Usa tapas en las ollas: Cocinar con tapas reduce el tiempo y la energía, Utiliza microondas y ollas de presión: Son más eficientes que usar la estufa.", color: .yellow)
        arrTip.append(tip)
        
        tip = TipsModel(tipName: "¿Qué electrodomésticos gastan más energía?", description: "Algunos electrodomésticos son conocidos por consumir más energía que otros. Aquí tienes una lista de los electrodomésticos que generalmente gastan más energía en el hogar:", estrategia1: "Aire acondicionado", textEs1: "Especialmente en climas cálidos, puede ser uno de los mayores consumidores de energía.", estrategia2: "Calefacción eléctrica", textEs2: "Los calefactores eléctricos son muy eficaces, pero también consumen mucha energía.", estrategia3: "Agua caliente (calentador de agua)", textEs3: "Los calentadores de agua, especialmente los eléctricos, son grandes consumidores de energía.", estrategia4: "Secadora de ropa", textEs4: "Utiliza mucha energía para calentar el aire y secar la ropa.", estrategia5: "Refrigerador", textEs5: "Aunque están diseñados para ser eficientes, un refrigerador viejo puede consumir mucha energía.", color: .green)
        arrTip.append(tip)
        
        tip = TipsModel(tipName: "¿Vale la pena invertir en paneles solares para mi hogar?", description: "La pregunta de si vale la pena invertir en paneles solares depende de varios factores, como el costo inicial, las condiciones locales (clima, orientación de la casa), las tarifas eléctricas y las subvenciones o incentivos disponibles. Sin embargo, en general, la inversión en paneles solares puede ser muy rentable a largo plazo por varias razones:", estrategia1: "Reducción de la factura de electricidad:", textEs1: "Los paneles solares generan energía gratuita a partir del sol, lo que significa que puedes reducir significativamente (o incluso eliminar) tu dependencia de la electricidad de la red.", estrategia2: "Incentivos fiscales y subvenciones:", textEs2: "En muchos lugares, existen incentivos fiscales, subsidios o ayudas para la instalación de paneles solares, lo que reduce el costo inicial de la inversión.", estrategia3: "Valor de reventa de la propiedad:", textEs3: "Las casas equipadas con sistemas solares tienden a tener un mayor valor de reventa.", estrategia4: "Beneficios medioambientales:", textEs4: "Los paneles solares son una fuente de energía limpia, lo que significa que reducen tu huella de carbono al disminuir la necesidad de energía proveniente de combustibles fósiles.", estrategia5: "Protección contra el aumento de precios de la electricidad:", textEs5: "Las tarifas de electricidad tienden a aumentar con el tiempo debido a la inflación y el aumento de la demanda de energía.", color: .orange)
        arrTip.append(tip)
        
        tip = TipsModel(tipName: "¿Cómo puedo mejorar el aislamiento térmico de mi casa?", description: "Mejorar el aislamiento térmico de tu casa es una de las mejores maneras de reducir el consumo energético y mantener una temperatura confortable durante todo el año. Aquí te explico cómo puedes mejorar el aislamiento térmico de tu hogar, junto con algunos tips prácticos:", estrategia1: "Revisa y mejora el aislamiento de las paredes y techos:", textEs1: "Las paredes y techos son los principales conductos por los que se pierde calor en invierno y se gana calor en verano.", estrategia2: "Sella las ventanas y puertas:", textEs2: "Las ventanas y puertas son puntos críticos de fuga de calor. Si no están bien selladas, el aire frío de invierno puede entrar y el aire caliente escapar, y viceversa en verano.", estrategia3: "Aislar el suelo:", textEs3: "El suelo también puede ser una fuente significativa de pérdida de calor, especialmente si tienes un suelo de concreto o una base sin aislamiento.", estrategia4: "Aislar las tuberías y conductos de calefacción y aire acondicionado:", textEs4: "Las tuberías de agua caliente o los conductos de aire acondicionado pueden ser grandes culpables de la pérdida de calor, especialmente si pasan a través de áreas frías o sin aislamiento.", estrategia5: "Mejorar el aislamiento del ático o desván:", textEs5: "Un desván mal aislado puede causar que el calor se acumule en el verano y escape en el invierno, lo que afecta la temperatura general de tu hogar.", color: .yellow)
        arrTip.append(tip)
        
        tip = TipsModel(tipName: "¿Cómo puedo usar mi aire acondicionado de manera más eficiente?", description: "Usar el aire acondicionado de manera más eficiente no solo reduce el consumo energético de tu hogar, sino que también puede prolongar la vida útil del equipo y mantener tus facturas de electricidad bajo control. A continuación te doy algunas recomendaciones sobre cómo maximizar la eficiencia de tu aire acondicionado:", estrategia1: "Ajusta la temperatura de manera inteligente:", textEs1: "Uno de los factores clave para mejorar la eficiencia del aire acondicionado es ajustar la temperatura de manera adecuada.", estrategia2: "Usa un termostato programable o inteligente:", textEs2: "Un termostato inteligente o programable te permite ajustar la temperatura según tu rutina diaria, evitando que el aire acondicionado funcione cuando no lo necesitas.", estrategia3: "Mantenimiento regular del aire acondicionado:", textEs3: "El mantenimiento adecuado de tu aire acondicionado es esencial para garantizar que funcione a su máxima eficiencia. Un sistema que no está bien cuidado puede perder entre un 5% y un 15% de eficiencia energética.", estrategia4: "Optimiza la circulación del aire en tu hogar:", textEs4: "El aire acondicionado trabaja de manera más eficiente cuando el aire puede circular libremente por las habitaciones.", estrategia5: "Mejora el aislamiento y el sellado de tu hogar:", textEs5: "Si tu hogar tiene filtraciones de aire, el aire frío escapará y el aire acondicionado trabajará más de lo necesario para mantener la temperatura.", color: .green)
        arrTip.append(tip)
        
        tip = TipsModel(tipName: "¿Es más eficiente utilizar bombillas LED en lugar de halógenas?", description: "Sí, es mucho más eficiente utilizar bombillas LED en lugar de bombillas halógenas. Las bombillas LED ofrecen una eficiencia energética significativamente superior, lo que se traduce en un menor consumo de electricidad y, por lo tanto, un ahorro a largo plazo. A continuación, te explico por qué las bombillas LED son la opción más eficientes:", estrategia1: "Consumo de energía mucho menor:", textEs1: "Las bombillas LED son mucho más eficientes que las halógenas en términos de consumo de energía. Por ejemplo, una bombilla LED de 10 vatios puede producir la misma cantidad de luz que una bombilla halógena de 50 vatios.", estrategia2: "Mayor durabilidad:", textEs2: "Las bombillas LED tienen una vida útil mucho más larga que las halógenas. Mientras que una bombilla halógena típicamente dura alrededor de 1,000 horas, una bombilla LED puede durar entre 15,000 y 50,000 horas, dependiendo del modelo.", estrategia3: "Menos calor generado:", textEs3: "Las bombillas halógenas son muy ineficientes en cuanto a la conversión de energía. Alrededor del 90% de la energía que consumen se convierte en calor en lugar de luz.", estrategia4: "Mejor calidad de luz y opciones de diseño:", textEs4: "Las bombillas LED proporcionan una mejor calidad de luz en comparación con las bombillas halógenas. Además, los LEDs son mucho más versátiles en términos de color, intensidad y dirección de la luz, lo que te permite adaptar la iluminación a tus necesidades específicas.", estrategia5: "Impacto ambiental menor:", textEs5: "Las bombillas LED no contienen mercurio, a diferencia de las bombillas fluorescentes compactas, y tienen un impacto ambiental menor en términos de residuos, ya que son más duraderas y requieren menos reemplazos.", color: .orange)
        arrTip.append(tip)
        
        tip = TipsModel(tipName: "¿Cuáles son las mejores formas de aprovechar la luz natural durante el día?", description: "Aprovechar la luz natural durante el día es una excelente forma de reducir el consumo de energía en tu hogar, mejorar tu bienestar y hacer un uso más eficiente de los recursos naturales:", estrategia1: "Usa las ventanas estratégicamente:", textEs1: "Las ventanas son la principal vía por la que entra la luz natural, así que es importante colocarlas en lugares clave de tu hogar.", estrategia2: "Mantén las ventanas limpias:", textEs2: "Aunque parece un consejo obvio, las ventanas sucias pueden reducir la cantidad de luz natural que entra en tu hogar. Las partículas de polvo, suciedad o residuos de agua pueden bloquear la luz y hacer que la casa se sienta más oscura.", estrategia3: "Utiliza colores claros en paredes y techos:", textEs3: "Los colores de las superficies dentro de tu hogar influyen directamente en cómo se distribuye y refleja la luz natural. Las paredes y techos oscuros tienden a absorber la luz, mientras que los colores claros reflejan la luz y ayudan a distribuirla de manera más eficiente por toda la habitación.", estrategia4: "Usa espejos y superficies reflectantes:", textEs4: "Los espejos y otras superficies reflectantes pueden ayudar a redirigir y distribuir la luz natural que entra en la habitación, haciendo que la luz se expanda a áreas más alejadas de las ventanas.", estrategia5: "Abre cortinas y persianas durante el día:", textEs5: "Para aprovechar al máximo la luz natural, es fundamental abrir las cortinas y persianas cuando hay luz exterior. Las cortinas gruesas o las persianas cerradas pueden bloquear el paso de la luz, limitando el uso de la luz solar en el interior.", color: .yellow)
        arrTip.append(tip)

    }
    /*
    .task {
        charactersVM.getCharacterInfo { result in
            switch result {
            case .success(let characters):
                print("Characters fetched successfully: \(characters)")
            case .failure(let error):
                print("Error fetching characters: \(error)")
            }
        }
    }
    */
}

