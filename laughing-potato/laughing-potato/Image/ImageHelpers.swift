//
//  ImageHelpers.swift
//  laughing-potato
//
//  Created by m1_air on 8/9/24.
//

import Foundation
import SwiftUI
import PhotosUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    func loadImage(from url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            image = UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}

struct AsyncAwaitImageView: View {
    @StateObject private var imageLoader = ImageLoader()
    let imageUrl: URL

    var body: some View {
        Group {
            if let image = imageLoader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                await imageLoader.loadImage(from: imageUrl)
            }
        }
    }
}
    
    /// A class that manages an image that a person selects in the Photos picker.
@MainActor final class ImageAttachment: ObservableObject, Identifiable {
  
    @Published var selection = [PhotosPickerItem]() {
        didSet {
            attachments.removeAll()
            // Update the attachments according to the current picker selection.
            _ = selection.map { item in
                Task {
                    // Retrieve selected asset in the form of Data
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        attachments.append(data)
                    }
                }
            }
        
        }
    }
    
    /// An array of image attachments for the picker's selected photos.
    @Published var attachments = [Data]()
   
}
