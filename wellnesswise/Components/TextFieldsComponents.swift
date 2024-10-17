//
//  TextFieldsComponents.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/10/2024.
//

import SwiftUI

struct TextFieldsComponents: View {

    
    var body: some View {
        
        
        TextField(
            "Email",
            text: $value
        )
        .textInputAutocapitalization(.never)
        .disableAutocorrection(true)
        
        
        
        
        SecureField (
            "Password",
            text:  password
        )
        .disableAutocorrection(true)
        .textInputAutocapitalization(.never)
        
        
        
    }
}
    
#Preview {
    TextFieldsComponents()
}
