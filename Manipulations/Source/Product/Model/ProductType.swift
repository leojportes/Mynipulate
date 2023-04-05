//
//  ProductType.swift
//  Manipulations
//
//  Created by Leonardo Portes on 15/02/23.
//

import Foundation

public enum ProductType: String, Codable {
    case seafood = "seafood"
    case meat = "meat"
    case fish = "fish"
    case choiceLegend = "choiceLegend"

    public var rawValue: String {
        switch self {
        case .seafood: return "Fruto do mar"
        case .meat: return "Carne"
        case .fish: return "Peixe"
        case .choiceLegend: return "Escolha um tipo de produto"
        }
    }

    public var iconTitle: String {
        switch self {
        case .seafood: return "seafood"
        case .meat: return "meat"
        case .fish: return "fish"
        case .choiceLegend: return "fish"
        }
    }
}
