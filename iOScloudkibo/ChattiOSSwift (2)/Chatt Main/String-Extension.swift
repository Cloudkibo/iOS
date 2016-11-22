//
//  String-Extension.swift
//  kiboApp
//
//  Created by Cloudkibo on 22/11/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

extension String {
    func trunc(length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
