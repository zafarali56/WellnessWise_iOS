//
//  HomeWidgets.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/12/2024.
//

import SwiftUI

//Bindings
//Place holders
struct HomeWidgets: View {
	var title: String
	var subtitle: String
	var imageName: String
	var backgroundColor: Color
	
	var body: some View {
		HStack {
			VStack{
				Image(imageName)
					.resizable()
					.scaledToFit()
					.frame(width: 70, height: 40)
				
				Text(title)
					.font(.headline)
					.foregroundColor(.white)
			}
			
			Spacer()
			Text(subtitle)
				.font(.largeTitle)
				.foregroundColor(.white.opacity(0.7))
				.fontDesign(.rounded)
				.fontWeight(.bold)
		}
		.padding()
		.frame(width: .infinity, height: 110)
		.background(backgroundColor)
		.cornerRadius(15)
		.shadow(radius: 5)
	}
}

#Preview {
	HomeWidgets(
		title: "",
		subtitle: "",
		imageName: "",
		backgroundColor: Color.accentColor
	)
}
