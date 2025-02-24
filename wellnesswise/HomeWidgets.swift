//
//  HomeWidgets.swift
//  wellnesswise
//
//  Created by Zafar Ali on 17/12/2024.
//
import SwiftUI
struct HomeWidgets: View {
	var title: String
	var subtitle: String
	var imageName: String
	var backgroundColor: Color
	var width: CGFloat

	var body: some View {
		HStack { 
			VStack {
				Image(imageName)
					.resizable()
					.scaledToFit()
					.frame(width: width, height: 50)
					.shadow(radius: 10)
				
				Text(title)
					.font(.subheadline)
					.foregroundColor(.primary)
			}
			
			Spacer()
			
			Text(subtitle)
				.font(.title2)
				.foregroundColor(.primary)
				.fontDesign(.rounded)
				.fontWeight(.bold)
				.shadow(radius: 2)
		}
		.padding()
		.frame(maxWidth: .infinity, maxHeight: 100)
		.background(
			ZStack {
				LinearGradient(
					gradient: Gradient(colors: [backgroundColor.opacity(0.3), backgroundColor]),
					startPoint: .topLeading,
					endPoint: .bottomTrailing
				)
				.clipShape(RoundedRectangle(cornerRadius: 20))
				
				RoundedRectangle(cornerRadius: 20)
					.fill(Material.ultraThin)
			}
		)
		.cornerRadius(20)
		.shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)
	}
}

struct HomeWidgetsPreview: View {
	var body: some View {
		VStack(spacing: 20) {
			HomeWidgets(
				title: "Heart Rate",
				subtitle: "72 bpm",
				imageName: "hr",
				backgroundColor: Color.red,
				width: 50
			)
			
			HomeWidgets(
				title: "Blood Sugar",
				subtitle: "90 mg/dL",
				imageName: "bs",
				backgroundColor: Color.blue,
				width: 50
			)
			
			HomeWidgets(
				title: "Cholesterol",
				subtitle: "180 mg/dL",
				imageName: "ch",
				backgroundColor: Color.green,
				width: 50
			)
			HomeWidgets(
				title: "Blood Pressure",
				subtitle: "120/80",
				imageName: "bp",
				backgroundColor: Color.purple,
				width: 50
			)
		}
		.padding()
		.background(Color.gray.opacity(0.1))
	}
}

#Preview {
	HomeWidgetsPreview()
}
