//
//  SearchViewModel.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {

    @Published var searchTerm = ""
    @Published var searchResults: [Media] = []
    @Published var noResultsFound = false
    @Published var showErrorAlert = false
    @Published var isLoadingMore = false
    @Published var isFetchingInitialResults = false
    
    private var subscriptions = Set<AnyCancellable>()
    private var requestSubscription: AnyCancellable?
    private var previousQuery: SearchQuery?
    private var resultIds: [Int: Int] = [:]
    private var loadingMoreComplete = false
    private let baseURL = "https://itunes.apple.com/search"
    
    func search() {
        guard !searchTerm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            resetSearch()
            return
        }

        let newQuery = SearchQuery(term: searchTerm)

        if let previousQuery = previousQuery,
           previousQuery.term == newQuery.term,
           previousQuery.media == newQuery.media {
            // duplicate search
            return
        }

        resetSearch()
        previousQuery = newQuery
        sendRequest(with: newQuery)
    }
    
    private func sendRequest(with query: SearchQuery) {
        if searchResults.count == 0 {
            isFetchingInitialResults = true
        }
        
        requestSubscription = NetworkService(baseURLString: baseURL)
            .getPublisherForResponse(endpoint: "", queryParameters: query.toDictionary)

            .sink { [weak self] completion in
                self?.isFetchingInitialResults = false
                if case .failure(let error) = completion {
                    self?.handleSearchError(error)
                }
            } receiveValue: { [weak self] (apiResponse: MediaList) in
                self?.handleSearchResults(apiResponse.results)
            }
    }
    
    private func handleSearchResults(_ results: [Media]) {
        guard results.count > 0 else {
            if isLoadingMore {
                stopLoadingMore()
            } else {
                noResultsFound = true
            }
            return
        }
        searchResults += results
    }
    
    func loadMore() {
        guard !loadingMoreComplete else {
            stopLoadingMore()
            return
        }

        isLoadingMore = true

        if var query = previousQuery {
            query.offset = searchResults.count
            previousQuery = query
            sendRequest(with: query)
            return
        }
    }
    
    private func handleSearchError(_ error: Error) {
        print("ERROR: \(error.localizedDescription)")
        showErrorAlert = true
        isLoadingMore = false

        previousQuery = nil
    }
    
    private func stopLoadingMore() {
        isLoadingMore = false
        loadingMoreComplete = true
    }
    
    private func resetSearch() {
        searchResults = []
        resultIds = [:]
        noResultsFound = false
        previousQuery = nil
        isLoadingMore = false
        loadingMoreComplete = false
        requestSubscription = nil
    }
}
