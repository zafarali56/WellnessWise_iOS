//
//  WelcomeScreen.swift
//  wellnesswise
//
//  Created by Zafar Ali on 28/01/2025.
//

import SwiftUI

struct WelcomeScreen: View {
	@AppStorage("isWelcomeShown") var isWelcomeShown: Bool = true
	var body: some View {
		VStack{
			Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
		}.sheet(isPresented: $isWelcomeShown){
			WelcomeView(isWelcomeShown: $isWelcomeShown)
		}
	}
	
}



#Preview {
	WelcomeScreen()
}

struct pageInfo : Identifiable {
	let id = UUID()
	let lable : String
	let text : String
	let image : String
	
}

let pages = [
	pageInfo(lable: "dummy", text: "dummy", image: "ddmyy"),
	pageInfo(lable: "dummy2", text: "dummy2", image: "Dummy2")
]


struct WelcomeView: View {
	@Binding var isWelcomeShown : Bool
	var body: some View {
		VStack {
			TabView{
				ForEach (pages){ page in
					VStack {
						Text(page.lable)
							.font(.largeTitle)
							.fontWeight(.semibold)
							.multilineTextAlignment(.center)
						
						
						Text(page.text)
							.fontWeight(.regular)
						
						Text(page.image)
						// todo .resizable
						// aspect ratio to .fit
						// some padding just incase
					}
					
				}
			}
			Button {
				isWelcomeShown.toggle()
				
			} label: {
				Text("Ok")
					.font(.title3)
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity)
					.padding(.vertical)
			}
		}.interactiveDismissDisabled()
			.tabViewStyle(.page)
			.onAppear{
				UIPageControl
					.appearance().currentPageIndicatorTintColor = .label
				UIPageControl.appearance().pageIndicatorTintColor = .systemGray
			}
	}
}
