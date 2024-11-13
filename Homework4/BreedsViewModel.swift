import Combine
import UIKit

class BreedsViewModel {
    private let catAPIService = CatAPIService()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var breeds: [Breed] = []
    @Published var breedImages: [String: UIImage] = [:] 
    @Published var isLoading = false
    
    func loadBreeds() {
        isLoading = true
        
        catAPIService.fetchCatBreeds()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Failed to fetch breeds: \(error)")
                }
            }, receiveValue: { [weak self] breeds in
                self?.breeds = breeds
                self?.loadBreedImages(for: breeds)
            })
            .store(in: &cancellables)
    }
    
    private func loadBreedImages(for breeds: [Breed]) {
        let publishers = breeds.map { breed in
            catAPIService.fetchCats(limit: 1, breedID: breed.id)
                .compactMap { $0.first?.url }
                .flatMap { urlString -> AnyPublisher<UIImage?, Never> in
                    guard let url = URL(string: urlString) else {
                        return Just(nil).eraseToAnyPublisher()
                    }
                    return self.catAPIService.fetchImage(at: url)
                                             .replaceError(with: nil)
                                             .eraseToAnyPublisher()
                }
                .replaceError(with: nil)
                .map { image in (breed.id, image) }
                .eraseToAnyPublisher()
        }
        
        Publishers.MergeMany(publishers)
            .collect()
            .sink { [weak self] results in
                for (breedID, image) in results {
                    if let image = image {
                        self?.breedImages[breedID] = image
                    }
                }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
