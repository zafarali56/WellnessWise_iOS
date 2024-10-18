//
//  AuthDesign.swift
//  wellnesswise
//
//  Created by Zafar Ali on 18/10/2024.
//

import SwiftUI

struct AuthDesign: View {
    let title : String
    let title2 : String
    var body: some View {
        VStack {
            HStack{Spacer()}
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(title2)
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .frame(height: 260)
                .padding(.leading)
                .foregroundColor(.white)
    }
}

#Preview {
    AuthDesign(title: "", title2: "")
}
