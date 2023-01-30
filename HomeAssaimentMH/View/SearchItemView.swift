//
//  SearchItemView.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import SwiftUI

struct SearchItemView: View {
    var media: Media

    var body: some View {
        NavigationLink {
            MediaDetailsView(media: media)
        } label: {
            HStack(alignment: .top, spacing: 24) {
                AsyncImage(url: media.imageUrl) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if phase.error != nil {
                        let _ = print("ERROR: Loading image \(media.imageUrl)")

                        Image(systemName: "photo")
                            .aspectRatio(contentMode: .fill)
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 100, height: 100)

                VStack(alignment: .leading, spacing: 10) {
                    Text(media.artistName ?? "")
                        .lineLimit(2)
                    Text(media.name ?? "")
                        .lineLimit(3)
                }
            }
        }
    }
}
