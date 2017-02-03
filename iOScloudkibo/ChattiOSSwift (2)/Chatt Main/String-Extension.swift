//
//  String-Extension.swift
//  kiboApp
//
//  Created by Cloudkibo on 22/11/2016.
//  Copyright © 2016 MyAppTemplates. All rights reserved.
//

import Foundation

extension String {
    func trunc(_ length: Int, trailing: String? = "...") -> String {
        if self.characters.count > length {
            return self.substring(to: self.characters.index(self.startIndex, offsetBy: length)) + (trailing ?? "")
        } else {
            return self
        }
    }
}
