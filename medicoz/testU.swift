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
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            }
            
            Button("Select Image") {
                isShowingImagePicker = true
            }
            .sheet(isPresented: $isShowingImagePicker) {
                imagePicker(image: $selectedImage)
            }
        }
    }
}





struct testU_Previews: PreviewProvider {
    static var previews: some View {
        testU()
    }
}
