import SwiftUI

struct StyledTextField: View {
	let title: String
	let placeholder: String
	@State var text: String
	var isSecure: Bool = false
	@FocusState private var isFocused: Bool
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
				}
				else {
					TextField (placeholder, text: $text)
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
		
		//Error message
		
		if let errorMessage = validateInput () {
			Text(errorMessage)
				.font(.caption)
				.foregroundStyle(.red)
				.padding(.top, 4)
				.padding(.leading, 4)
		}

	}
	private func validateInput() -> String? {
		return nil
	}
}

#Preview {
	StyledTextField(title: "", placeholder: "", text: "")
}

struct StyledTextFieldPreview: View {
	@State private var text1 = ""
	@State private var text2 = ""
	@State private var secureText = ""
	
	var body: some View {
		VStack(spacing: 20) {
			StyledTextField(
				title: "Email",
				placeholder: "Enter your email",
				text: text1
			)
			
			StyledTextField(
				title: "Username",
				placeholder: "Enter username",
				text: text2
			)
			
			StyledTextField(
				title: "Password",
				placeholder: "Enter password",
				text: secureText,
				isSecure: true
			)
		}
		.padding()
	}
}

#Preview {
	StyledTextFieldPreview()
}
