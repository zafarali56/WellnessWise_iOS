import SwiftUI

struct StyledTextField: View {
	let title: String
	let placeholder: String
	@Binding var text: String
	var isSecure: Bool = false
	@FocusState private var isFocused: Bool
	var isNumber: Bool = false
	var body: some View {
		VStack (alignment: .leading, spacing : 4 )
		{
			Text (title)
				.font(.subheadline)
				.foregroundStyle(.secondary)
		}
		HStack {
			Group{
				if isSecure {
					SecureField(placeholder , text: $text)
						.autocorrectionDisabled()
						.textInputAutocapitalization(
							TextInputAutocapitalization
								.never)
	
				}
				
				else if isNumber {
					TextField (placeholder , text: $text)
						.autocorrectionDisabled()
						.keyboardType(.numberPad)
				}
				
				else {
					TextField (placeholder, text: $text)
						.autocorrectionDisabled()
						.textInputAutocapitalization(
							TextInputAutocapitalization
								.never)
				}
				
			}.textFieldStyle(PlainTextFieldStyle())
				.font(.body)
				.focused($isFocused)
			
			
			
			if !text.isEmpty {
				Button(action: {
					text = ""
				}) {
					Image(systemName: "xmark.circle.fill")
						.foregroundColor(.secondary)
						.opacity(0.7)
				}
				.transition(.opacity)
				.animation(.easeInOut, value: text)
			}
			
		}
		.padding(.horizontal,12)
		.padding(.vertical,8)
		.background{
			RoundedRectangle(cornerRadius: 10)
				.fill(.ultraThinMaterial)
				.overlay(RoundedRectangle(cornerRadius: 10)
					.strokeBorder(
						isFocused ? Color.blue : Color.gray.opacity(0.3),
						lineWidth: isFocused ? 2 : 1
					))
		}
		
	}
	
	
}
