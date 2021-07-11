//
//  Array+addItem.swift
//  Photo Editor for CFT
//
//  Created by Алина Квашнина on 06.07.2021.
//

import Foundation

extension Array{
    mutating func appendAtBeginning(newItem : Element){
        let copy = self
        self = []
        self.append(newItem)
        self.append(contentsOf: copy)
    }
}
