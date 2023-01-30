//
//  SearchListView.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import SwiftUI
import DebouncedOnChange

struct SearchListView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
    var body: some View {
        ZStack {
            list

            if searchViewModel.isFetchingInitialResults {
                ProgressView()
            }

            if searchViewModel.noResultsFound {
                Text("No results found.")
                    .bold()
            }
        }
        .navigationTitle("Podcast Search")
        .searchable(text: $searchViewModel.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchViewModel.searchTerm, debounceTime: 0.5) { newValue in
            searchViewModel.search()
        }
    }
    
    var list: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchViewModel.searchResults) { item in
                    Section(footer: footer(for: item)) {
                        SearchItemView(media: item)

                        Divider()
                            .onAppear {
                                if searchViewModel.searchResults.count > 0,
                                    item == searchViewModel.searchResults.last! {
                                    searchViewModel.loadMore()
                                }
                            }
                    }
                }
            }
            .padding([.all], 16)
        }
    }
    
    @ViewBuilder
    func footer(for media: Media) -> some View {
        if searchViewModel.isLoadingMore,
           searchViewModel.searchResults.count > 0,
           media == searchViewModel.searchResults.last! {
            HStack {
                Spacer()

                ProgressView("Loading...")
                    .padding([.top, .bottom], 10)

                Spacer()
            }
        }  else {
            EmptyView()
        }
    }
}
