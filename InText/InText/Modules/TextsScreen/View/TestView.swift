import SwiftUI
import ImageOCRUI

struct TestView: View {
    @State private var texts: [ScannedText] = []
    @State private var showScannerSheet = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(texts) { text in
                        Text(text.scannedText)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            texts.remove(at: index)
                        }
                    }
                }

            }
            .navigationTitle("OCR Image to Text")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Scan") {
                        showScannerSheet = true
                    }
                    .sheet(isPresented: $showScannerSheet) {
                        self.createScannerView()
                    }
                }
            }
        }
    }

    private func createScannerView() -> ScannerView {
        ScannerView(completion: { detectedTextPerPage in
            if let concatenatedText = detectedTextPerPage?.joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines) {
                let scannedData = ScannedText(scannedText: concatenatedText)
                self.texts.append(scannedData)
            }
            self.showScannerSheet = false
        })
    }
}

