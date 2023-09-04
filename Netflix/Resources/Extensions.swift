//
//  Extensions.swift
//  Netflix
//
//  Created by Дмитрий Процак on 01.12.2022.
//

import Foundation

extension String {
    func capitalizerFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
