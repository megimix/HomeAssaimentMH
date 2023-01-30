//
//  ContentView.swift
//  HomeAssaimentMH
//
//  Created by Tal Shachar on 29/01/2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationStack{
            SearchListView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
