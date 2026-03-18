// MARK: - Legal modal (Spin-inspired: frosted glass, white text, neon Done)
import SwiftUI

private let legalNeonGreen = Color(hex: "3FFD98")
private let legalTextWhite = Color.white
private let legalTextOffWhite = Color(white: 0.96)

struct LegalModal: View {
    let title: String
    let content: String
    let onDismiss: () -> Void

    private let topId = "top"

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .background(.ultraThinMaterial)

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(legalNeonGreen)
                            .frame(width: 44, height: 44)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(legalTextWhite)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 8)

                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 16) {
                            Color.clear
                                .frame(height: 1)
                                .id(topId)

                            legalBodyView
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    }
                    .onAppear {
                        proxy.scrollTo(topId, anchor: .top)
                    }
                }

                Button(action: onDismiss) {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(legalNeonGreen)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
    }

    private var legalBodyView: some View {
        let paragraphs = content.split(separator: "\n", omittingEmptySubsequences: false)
        return VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(paragraphs.enumerated()), id: \.offset) { _, line in
                let str = String(line)
                if isSectionHeader(str) {
                    Text(str)
                        .font(.system(size: 15, weight: .bold, design: .default))
                        .foregroundStyle(legalTextWhite)
                } else if !str.isEmpty {
                    Text(str)
                        .font(.system(size: 14, weight: .regular, design: .default))
                        .foregroundStyle(legalTextOffWhite)
                }
            }
        }
    }

    private func isSectionHeader(_ line: String) -> Bool {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 3 else { return false }
        let arr = Array(trimmed)
        if arr[0].isNumber && arr[1] == "." && (arr.count == 2 || arr[2] == " " || arr[2].isUppercase) {
            return true
        }
        if trimmed.hasPrefix("📜") { return true }
        return false
    }
}

#Preview("Legal Modal") {
    LegalModal(
        title: LegalData.termsOfServiceTitle,
        content: String(LegalData.termsOfService.prefix(800)) + "...",
        onDismiss: {}
    )
}
