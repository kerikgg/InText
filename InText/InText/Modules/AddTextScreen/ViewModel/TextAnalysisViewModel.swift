//import Foundation
//
//final class TextAnalysisViewModel: ObservableObject {
//    @Published var summary: String?
//    @Published var keywords: [String] = []
//    @Published var isAnalyzing = false
//
//    private let text: TextModel
//    private let nlpService = NLPService()
//    private let textService = CoreDataService.shared
//
//    init(text: TextModel) {
//        self.text = text
//        self.summary = text.summary
//        self.keywords = text.keywords ?? []
//    }
//
//    func analyze() {
//        guard !isAnalyzing else { return }
//
//        isAnalyzing = true
//
//        nlpService.analyze(text: text.content) { [weak self] summary, keywords in
//            DispatchQueue.main.async {
//                self?.summary = summary
//                self?.keywords = keywords ?? []
//                self?.isAnalyzing = false
//
//                guard let summary, let keywords else { return }
//                self?.textService.updateAnalysis(for: self?.text.id ?? "", summary: summary, keywords: keywords)
//            }
//        }
//    }
//}
//
//import Foundation
//
//final class TextAnalysisViewModel: ObservableObject {
//    @Published var summary: String?
//    @Published var keywords: [String] = []
//    @Published var isAnalyzing = false
//
//    private let text: TextModel
//    private let textService = CoreDataService.shared
//
//    init(text: TextModel) {
//        self.text = text
//        self.summary = text.summary
//        self.keywords = text.keywords ?? []
//    }
//
//    func analyze() {
//        guard !isAnalyzing else { return }
//        isAnalyzing = true
//
//        NLPService().analyze(text: text.content) { [weak self] summary, keywords in
//            DispatchQueue.main.async {
//                self?.summary = summary
//                self?.keywords = keywords ?? []
//                self?.isAnalyzing = false
//
//                guard let summary, let keywords else { return }
//                self?.textService.updateAnalysis(
//                    for: self?.text.id ?? "",
//                    summary: summary,
//                    keywords: keywords
//                )
//            }
//        }
//    }
//}
import Foundation

@MainActor
final class TextAnalysisViewModel: ObservableObject {
    @Published var isAnalyzing = false
    @Published var summary: String?
    @Published var keywords: [String] = []
    @Published var analysisMode: AnalysisMode = .gpt


    func analyze(textModel: TextModel) {
        summary = nil
        keywords = []
        isAnalyzing = true

        switch analysisMode {
        case .gpt:
            NLPService.shared.analyze(text: textModel.content) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isAnalyzing = false
                    switch result {
                    case .success(let output):
                        self?.summary = output.summary
                        self?.keywords = output.keywords

                        // сохраняем
                        TextsService.shared.updateAnalysis(
                            for: textModel.id,
                            summary: output.summary,
                            keywords: output.keywords
                        )
                    case .failure(let error):
                        print("Ошибка GPT: \(error.localizedDescription)")
                    }
                }
            }

        case .local:
            DispatchQueue.global().async {
                let result = LocalAnalysisService.analyze(text: textModel.content)
                DispatchQueue.main.async {
                    self.isAnalyzing = false
                    self.summary = result.summary
                    self.keywords = result.keywords

                    TextsService.shared.updateAnalysis(
                        for: textModel.id,
                        summary: result.summary,
                        keywords: result.keywords
                    )
                }
            }
        }
        guard let summary = textModel.summary, let keywords = textModel.keywords else { return }
        TextsService.shared.updateAnalysis(for: textModel.id, summary: summary, keywords: keywords)
    }
    //    func analyze(text: String) {
    //        summary = nil
    //        keywords = []
    //        isAnalyzing = true
    //
    //        switch analysisMode {
    //        case .gpt:
    //            NLPService.shared.analyze(text: text) { [weak self] result in
    //                DispatchQueue.main.async {
    //                    self?.isAnalyzing = false
    //                    switch result {
    //                    case .success(let output):
    //                        self?.summary = output.summary
    //                        self?.keywords = output.keywords
    //                    case .failure(let error):
    //                        print("Ошибка GPT: \(error.localizedDescription)")
    //                    }
    //                }
    //            }
    //
    //        case .local:
    //            DispatchQueue.global().async {
    //                let result = LocalAnalysisService.analyze(text: text)
    //                DispatchQueue.main.async {
    //                    self.isAnalyzing = false
    //                    self.summary = result.summary
    //                    self.keywords = result.keywords
    //                }
    //            }
    //        }
    //
    //        TextsService.shared.updateAnalysis(for: text.id, summary: summary, keywords: keywords)
    //    }
}
