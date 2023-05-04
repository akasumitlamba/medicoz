//
//  testU.swift
//  medicoz
//
//  Created by Sachin Sharma on 05/04/23.
//

import SwiftUI
import Firebase
import FirebaseAuth



import SwiftUI
import Firebase
import FirebaseStorage

struct testU: View {
    @State private var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.3))
                .frame(width: 150, height: 80)
                .overlay {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(2).padding(20)
                }
        }
    }
}





struct testU_Previews: PreviewProvider {
    static var previews: some View {
        testU()
    }
}
