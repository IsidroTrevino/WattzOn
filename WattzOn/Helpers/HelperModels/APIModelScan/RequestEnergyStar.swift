//
//  RequestEnergyStar.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import Foundation

// Función para hacer la solicitud a la API
func fetchEnergyStarData(pd_id: String, completion: @escaping ([EnergyStarModel]?) -> Void) {
    // Construir la URL con el parámetro pd_id
    let urlString = "https://data.energystar.gov/resource/j7nq-iepp.json?pd_id=\(pd_id)"
    
    // Verificar que la URL es válida
    guard let url = URL(string: urlString) else {
        print("URL inválida")
        completion(nil)
        return
    }

    // Crear la solicitud
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    // Añadir la cabecera de autenticación `X-App-Token`
    let appToken = "D31YVCOgkJxJ2M3oPslkO3jR1" 
    request.addValue(appToken, forHTTPHeaderField: "X-App-Token")

    // Crear la tarea de URLSession para realizar la solicitud HTTP
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        // Manejar errores de red
        if let error = error {
            print("Error en la solicitud: \(error.localizedDescription)")
            completion(nil)
            return
        }

        // Verificar si se recibió una respuesta válida
        guard let data = data else {
            print("No se recibieron datos")
            completion(nil)
            return
        }

        // Intentar decodificar el JSON
        do {
            let decoder = JSONDecoder()
            let products = try decoder.decode([EnergyStarModel].self, from: data)
            completion(products)
        } catch let jsonError {
            print("Error al decodificar el JSON: \(jsonError)")
            completion(nil)
        }
    }

    // Ejecutar la tarea
    task.resume()
}


