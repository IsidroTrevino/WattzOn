//
//  EnergyStarModel.swift
//  WattzOn
//
//  Created by Fernando Espidio on 18/10/24.
//

import Foundation

// Estructura que representa un producto en el JSON
struct EnergyStarModel: Codable {
    let pd_id: String
    let energy_star_partner: String
    let brand_name: String
    let model_name: String
    let model_number: String
    let additional_model_information: String?
    let upc: String?
    let type: String
    let touch_screen: String
    let comp_cat_for_tec_typical_energy_consumption_criteria: String?
    let category_2_processor_brand: String
    let category_2_processor_name: String
    let category_2_operating_system_name: String
    let category_2_base_processor_speed_per_core_ghz: String
    let category_2_physical_cpu_cores_count: String
    let category_2_system_memory_gb: String
    let category_2_default_low_power_mode: String
    let category_2_off_mode_watts: String
    let category_2_sleep_mode_watts: String
    let category_2_long_idle_watts: String
    let category_2_short_idle_watts: String
    let category_2_base_tec_allowance_kwh: String
    let category_2_functional_adder_allowances_kwh: String
    let category_2_tec_of_model_kwh: String
    let ethernet_capability: String
    let date_available_on_market: String
    let date_qualified: String
    let markets: String
    let energy_star_model_identifier: String
}
