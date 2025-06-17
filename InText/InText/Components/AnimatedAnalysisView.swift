import SwiftUI

struct AnimatedAnalysisView: View {
    @State private var waveOffset: CGFloat = 0
    @State private var dots = ""

    let gradient = LinearGradient(
        gradient: Gradient(colors: [Color.purple.opacity(0.6), Color.cyan.opacity(0.6)]),
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                WaveShape(offset: waveOffset)
                    .stroke(gradient, lineWidth: 3)
                    .frame(height: 60)
                    .onAppear {
                        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
                            waveOffset = .pi * 2
                        }
                    }

                Text("Идёт анализ")
                    .font(.headline)
                    .foregroundColor(.purple)
            }

            Text("Пожалуйста, подождите\(dots)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                        dots = String(repeating: ".", count: (dots.count + 1) % 4)
                    }
                }
        }
        .padding()
    }
}

struct WaveShape: Shape {
    var offset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let amplitude: CGFloat = 10
        let frequency: CGFloat = 2

        path.move(to: CGPoint(x: 0, y: rect.midY))
        for x in stride(from: 0, through: rect.width, by: 1) {
            let relativeX = x / rect.width
            let sine = sin(relativeX * frequency * .pi + offset)
            let y = rect.midY + sine * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }

    var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }
}

#Preview {
    AnimatedAnalysisView()
}
