//
//  MediaDetailsView.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import SwiftUI

struct MediaDetailsView: View {
    var media: Media
    
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
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
            Text(media.artistName ?? "")
                .bold()
                .padding()
            Text(media.name ?? "")
                .padding()
            if let date = media.releaseDate {
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .padding()
            }
            Spacer()
        }
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailsView(media: Media(id: 1, name: "the fox", artistName: "please let me knoe hoe to help you find the ", imageUrl: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Podcasts125/v4/3e/6f/eb/3e6feb88-8d73-4ad1-7f85-bb57a60231d5/mza_16547704628105998931.png/100x100bb.jpg")!, releaseDate: Date()))
    }
}
