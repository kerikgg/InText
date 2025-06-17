import SwiftUI

struct AnalysisLoadingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 20)
                .redacted(reason: .placeholder)
                .shimmer()

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 16)
                .redacted(reason: .placeholder)
                .shimmer()

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(height: 16)
                .redacted(reason: .placeholder)
                .shimmer()
        }
    }
}

extension View {
    func shimmer() -> some View {
        self
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, Color.white.opacity(0.6), .clear]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: -200)
                .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false), value: UUID())
            )
            .mask(self)
    }
}

