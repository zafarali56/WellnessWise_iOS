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
	var width: CGFloat
	
	var body: some View {
		HStack {
			VStack{
				Image(imageName)
					.resizable()
					.scaledToFit()
					.frame(width: width, height: 50)
				
				Text(title)
					.font(.headline)
					.foregroundColor(.white)
			}
			
			Spacer()
			Text(subtitle)
				.font(.title2)
				.foregroundColor(.white)
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
		backgroundColor: Color.accentColor,
		width: 0
	)
}
