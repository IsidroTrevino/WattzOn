//
//  ReadingsNotes.swift
//  WattzOn
//
//  Created by Fernando Espidio on 06/11/24.
//

import Foundation

struct ReadingsNotes {
    struct Note {
        let title: String
        let explanation: String
    }

    static let fechaRegistro = Note(
        title: "Fecha de Emisión del Recibo",
        explanation: "Esta es la fecha en la que se emitió tu recibo de luz. Indica el periodo de facturación correspondiente y es importante para llevar un control de tus consumos mensuales."
    )

    static let lecturaAnterior = Note(
        title: "Lectura Anterior del Medidor",
        explanation: "Es la lectura del medidor registrada en el periodo anterior, medida en kilovatios-hora (kWh). Se utiliza para calcular el consumo actual al restarse de la lectura actual."
    )

    static let lecturaActual = Note(
        title: "Lectura Actual del Medidor",
        explanation: "Esta es la lectura actual de tu medidor en kilovatios-hora (kWh). Refleja el total acumulado de energía consumida hasta la fecha de lectura. Se utiliza para calcular el consumo del periodo actual."
    )

    static let totales = Note(
        title: "Consumo Total por Periodo",
        explanation: "Representa la cantidad total de energía consumida en cada periodo tarifario, expresada en kilovatios-hora (kWh). Los periodos pueden ser básico, intermedio y excedente, dependiendo de tu tarifa eléctrica."
    )

    static let precios = Note(
        title: "Precio por kWh en cada Periodo",
        explanation: "Indica el costo por kilovatio-hora para cada periodo tarifario. Estos precios son establecidos por la compañía eléctrica y pueden variar según el consumo y la tarifa aplicada."
    )

    static let totalFinales = Note(
        title: "Subtotal por Periodo",
        explanation: "Es el costo total para cada periodo tarifario, calculado multiplicando el consumo en kWh por el precio por kWh correspondiente. La suma de estos subtotales contribuye al total de tu recibo."
    )
}

//
//  ElectrodomesticoNotes.swift
//  WattzOn
//

import Foundation

struct ElectrodomesticoNotes {
    struct Note {
        let title: String
        let explanation: String
    }

    static let potenciaWatts = Note(
        title: "Potencia en Watts",
        explanation: """
        La potencia en watts (W) es la cantidad de energía que consume un electrodoméstico por unidad de tiempo. Indica cuánta electricidad utiliza el aparato cuando está en funcionamiento. Conocer la potencia te ayuda a calcular el consumo energético y el costo asociado al uso de tus electrodomésticos.

        Puedes encontrar la potencia en la etiqueta del fabricante, en el manual de usuario, o en algunas ocasiones, impresa directamente en el electrodoméstico.
        """
    )
}
