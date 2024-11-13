import Combine
import UIKit

class CatViewModel {
    private let catAPIService = CatAPIService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var catImage: UIImage?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func fetchCatImage() {
        isLoading = true
        catAPIService.fetchCats(limit: 1, format: "jpg", breedID: nil)
            .flatMap { cats -> AnyPublisher<UIImage?, Error> in
                guard let url = URL(string: cats.first?.url ?? "") else {
                    return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
                }
                return self.catAPIService.fetchImage(at: url)
            }
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] image in
                self?.catImage = image
            })
            .store(in: &cancellables)
    }
    
    func likeCat() {
        print("Liked the cat")
    }
    
    func dislikeCat() {
        print("Disliked the cat")
    }
}
