//
//  ViewCodeContract.swift
//  Manipulations
//
//  Created by Leonardo Portes on 29/12/22.
//

import Foundation

///Protocolo destinado a criação de views por código.
public protocol ViewCodeContract {
    
    /// Hierarquia de views
    func setupHierarchy()
    
    /// Ativação de constraints
    func setupConstraints()
    
    /// Configuração dos componentes
    func setupConfiguration()
}

public extension ViewCodeContract {
    
    func setupView() {
        setupHierarchy()
        setupConstraints()
        setupConfiguration()
    }
    
    func setupConfiguration() {
        /* Default implementation */
    }
}
