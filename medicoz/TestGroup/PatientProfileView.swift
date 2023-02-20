//
//  test2.swift
//  medicoz
//
//  Created by Sachin Sharma on 19/02/23.
//

import SwiftUI


struct CContentView: View {
    let items = [
        ("Item 1", "View 1"),
        ("Item 2", "View 2"),
        ("Item 3", "View 3"),
        ("Item 4", "View 4"),
        ("Item 5", "View 5"),
        ("Item 6", "View 6")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            LazyVGrid(columns: columns) {
                ForEach(items, id: \.0) { item in
                    NavigationLink(
                        destination: Text(item.1),
                        label: {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.blue)
                                .frame(height: 150)
                                .overlay(
                                    Text(item.0)
                                        .foregroundColor(.white)
                                )
                        }
                    )
                }
            }
            .padding()
            .navigationTitle("Items")
        }
    }
}



struct CContentView_Previews: PreviewProvider {
    static var previews: some View {
        CContentView()
    }
}
