import SwiftUI

struct StyledTextField: View {
	// MARK: - Properties
	let title: String
	let placeholder: String
	@Binding var text: String
	var isSecure: Bool = false
	var isNumber: Bool = false
	var isValid: Bool? = nil
	var errorMessage: String? = nil
	
	@FocusState private var isFocused: Bool
	
	// MARK: - Body
	var body: some View {
		VStack(alignment: .leading, spacing: 4) {
			// Title and validation status
			HStack {
				Text(title)
					.font(.subheadline)
					.foregroundStyle(.secondary)
				
				if let isValid = isValid, !text.isEmpty {
					Image(systemName: isValid ? "checkmark.circle.fill" : "exclamation.circle.fill")
						.foregroundStyle(isValid ? .green : .red)
						.font(.footnote)
				}
			}
			
			// TextField Container
			HStack {
				// Input Field
				Group {
					if isSecure {
						SecureField(placeholder, text: $text)
							.textInputAutocapitalization(.never)
							.autocorrectionDisabled()
					} else if isNumber {
						TextField(placeholder, text: $text)
							.keyboardType(.numberPad)
							.autocorrectionDisabled()
					} else {
						TextField(placeholder, text: $text)
							.textInputAutocapitalization(.never)
							.autocorrectionDisabled()
					}
				}
				.textFieldStyle(.plain)
				.font(.body)
				.focused($isFocused)
				
				// Clear Button
				if !text.isEmpty {
					Button(action: { text = "" }) {
						Image(systemName: "xmark.circle.fill")
							.foregroundStyle(.secondary)
							.opacity(0.7)
					}
					.transition(.opacity)
					.animation(.easeInOut, value: text)
				}
			}
			.padding(.horizontal, 12)
			.padding(.vertical, 8)
			.background {
				RoundedRectangle(cornerRadius: 10)
					.fill(.ultraThinMaterial)
					.overlay {
						RoundedRectangle(cornerRadius: 10)
							.strokeBorder(borderColor, lineWidth: borderWidth)
					}
			}
			
			// Error Message
			if let errorMessage = errorMessage, !text.isEmpty && isValid == false {
				Text(errorMessage)
					.font(.caption)
					.foregroundStyle(.red)
					.padding(.horizontal, 4)
					.transition(.opacity)
					.animation(.easeInOut, value: errorMessage)
			}
		}
	}
	
	// MARK: - Computed Properties
	private var borderColor: Color {
		if isFocused {
			return .blue
		}
		if let isValid = isValid, !text.isEmpty {
			return isValid ? .green : .red
		}
		return .gray.opacity(0.3)
	}
	
	private var borderWidth: CGFloat {
		if isFocused || (isValid == false && !text.isEmpty) {
			return 2
		}
		return 1
	}
}

// MARK: - Preview
#Preview {
	VStack(spacing: 20) {
		// Regular TextField
		StyledTextField(
			title: "Username",
			placeholder: "Enter username",
			text: .constant("john_doe"),
			isValid: true
		)
		
		// TextField with Error
		StyledTextField(
			title: "Email",
			placeholder: "Enter email",
			text: .constant("invalid-email"),
			isValid: false,
			errorMessage: "Please enter a valid email address"
		)
		
		// Secure TextField
		StyledTextField(
			title: "Password",
			placeholder: "Enter password",
			text: .constant("password123"),
			isSecure: true,
			isValid: true
		)
		
		// Number TextField
		StyledTextField(
			title: "Age",
			placeholder: "Enter age",
			text: .constant("25"),
			isNumber: true,
			isValid: true
		)
	}
	.padding()
}
