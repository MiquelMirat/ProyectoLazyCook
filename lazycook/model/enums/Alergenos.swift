//
//  Alergenos.swift
//  lazycook
//
//  Created by Miquel Mirat Soler on 12/04/2019.
//  Copyright © 2019 Bermiq. All rights reserved.
//

import Foundation

enum Alergenos: Int, CaseIterable, CustomStringConvertible{
    case gluten
    case crustaceos
    case huevos
    case pescado
    case cacahuetes
    case soja
    case lacteos
    case frutos_cascara
    case apio
    case mostaza
    case grano_sesamo
    case molusco
    case altramuces
    case sulfitos
    
    var name: String {
        switch self {
        case .gluten:           return "Gluten"
        case .crustaceos:       return "Crustáceos"
        case .huevos:           return "Huevos"
        case .pescado:          return "Pescado"
        case .cacahuetes:       return "Cacahuetes"
        case .soja:             return "Soja"
        case .lacteos:          return "Lácteos"
        case .frutos_cascara:   return "Frutos de cáscara"
        case .apio:             return "Apio"
        case .mostaza:          return "Mostaza"
        case .grano_sesamo:     return "Sésamo"
        case .molusco:          return "Moluscos"
        case .altramuces:       return "Altramuces y derivados"
        case .sulfitos:         return "Sulfitos"
        }
    }
    static var count: Int { return 14}
    
    var description: String {
        switch self {
            case .gluten:           return "Cereales con gluten (harina de trigo, avena, centeno, etc)"
            case .crustaceos:       return "Crustáceos y derivados (como el surimi)"
            case .huevos:           return "Huevo o trazas de huevo"
            case .pescado:          return "Pescado"
            case .cacahuetes:       return "Cacahuetes (o sus trazas)"
            case .soja:             return "Soja (o su aceite)"
            case .lacteos:          return "Leche y derivados (mantequilla y queso)"
            case .frutos_cascara:   return "Frutos de cáscara (nueces, avellanas, pistachos...)"
            case .apio:             return "Apio"
            case .mostaza:          return "Mostaza"
            case .grano_sesamo:     return "Sésamo"
            case .molusco:          return "Moluscos y derivados (surimi)"
            case .altramuces:       return "Altramuces y derivados (como su harina)"
            case .sulfitos:         return "Sulfitos y dióxido de azufre"
        }
    }
}
