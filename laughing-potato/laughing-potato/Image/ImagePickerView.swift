//
//  ImagePickerView.swift
//  laughing-potato
//
//  Created by m1_air on 8/9/24.
//

import SwiftUI
import PhotosUI


struct ImagePickerView: View {
    @Binding var media: [String]
    @State private var selectToggle: Bool = false
    @State private var selectedImage: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var saved: Bool = false

    
    var body: some View {
        
                    PhotosPicker(
                        selection: $selectedImage,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        if(selectToggle) {
                            if let selectedImageData,
                               let uiImage = UIImage(data: selectedImageData) {
                                VStack {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            }

                        } else {
                            Image(systemName: "camera.circle")
                                .resizable()
                                .foregroundStyle(.black)
                                .frame(width: 50, height: 50)
                        }
                    }
                    .onChange(of: selectedImage) { oldItem, newItem in
                        Task {
                            if let newItem = newItem,
                               let data = try? await newItem.loadTransferable(type: Data.self),
                               let originalUIImage = UIImage(data: data) {
                                
                                // Compress the image with the desired quality (e.g., 0.5 for medium quality)
                                let compressedImageData = originalUIImage.jpegData(compressionQuality: 0.2)
                                
                                // Use the compressed image data
                                selectedImageData = compressedImageData
                                
                                // Encode the compressed data to Base64 and append to media array
                                if let compressedImageData = compressedImageData {
                                    media.append(compressedImageData.base64EncodedString())
                                }
                                
                                // Toggle the selection
                                selectToggle.toggle()
                                
                                print(String(describing: _selectedImageData))
                            } else {
                                // Handle cases where either newItem is nil or data loading failed
                                print("Failed to load image data.")
                            }
                        }
                    }
            
        }
    }

