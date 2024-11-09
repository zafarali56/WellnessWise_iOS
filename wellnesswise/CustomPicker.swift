//
//  CustomPicker.swift
//  wellnesswise
//
//  Created by Zafar Ali on 09/11/2024.
//

import SwiftUI

struct CustomPicker <T: Hashable> : View {
	let headerText : String
	let pickerText : String
	let options : [T]
	@Binding var selected : String
	
	var body: some View {
		VStack(alignment: .leading) {
			Text(headerText)
			Picker(pickerText, selection: $selected ) {
				ForEach(options, id: \.self) { option in
					Text("\(String(describing: option))")
						.tag(option)
				}
			}
		}
	}
}

#Preview {
	@Previewable @State var selection = "Option 1"
	CustomPicker(
		headerText: "Sample Header",
		pickerText: "Select an option",
		options: ["Option 1", "Option 2", "Option 3"],
		selected: $selection
	)
	.padding()
}
