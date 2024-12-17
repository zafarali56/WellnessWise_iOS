//
//  HomeWidgets.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/12/2024.
//

import SwiftUI

struct HomeWidgets: View {
    var body: some View {
		ZStack{
				RoundedRectangle(cornerRadius: 20, style: .continuous)
				.fill(Color.blue.opacity(0.2))
				.overlay(
					RoundedRectangle(cornerRadius: 20)
						.stroke(Color.blue.opacity(0.3), lineWidth: 1)
				)
				.frame(width:.infinity, height: 100)
				.shadow(color: .black.opacity(0.2), radius: 10, x: 0, y:10)
		}
    }
}
#Preview {
	HomeWidgets()
}
