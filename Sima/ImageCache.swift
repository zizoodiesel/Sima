//
//  ImageCache.swift
//  Sima
//
//  Created by Zizoo diesel on 10/4/2023.
//

import UIKit
import Foundation
public class ImageCache {
    
    public static let publicCache = ImageCache()
    private var cachedImages = [NSURL: UIImage]()
    private var loadingResponses = [NSURL: [(IndexPath?, UIImage?) -> Swift.Void]]()
    
    public final func image(url: NSURL) -> UIImage? {
        return cachedImages[url]
    }

    // Returns the cached image if available, otherwise asynchronously loads and caches it.
    final func load(url: NSURL, indexPath: IndexPath?, completion: @escaping (IndexPath?, UIImage?) -> Swift.Void) {
        // Check for a cached image.
        if let cachedImage = image(url: url) {
            DispatchQueue.main.async {
                completion(indexPath, cachedImage)
            }
            return
        }
        // In case there are more than one request for the image, we append their completion block.
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        // Go fetch the image.
        URLSession.shared.dataTask( with: url as URL, completionHandler: {
            (data, response, error) -> Void in
            
            guard let responseData = data, let image = UIImage(data: responseData),
                let blocks = self.loadingResponses[url], error == nil else {
                DispatchQueue.main.async {
                    completion(indexPath, nil)
                    
                    // epmty the blocks array if error
                    self.loadingResponses[url]?.removeAll()
                    self.loadingResponses[url] = nil
                }
                return
            }
            // Cache the image.
            self.cachedImages[url] = image
            // Iterate over each requestor for the image and pass it back.
            for block in blocks {
                DispatchQueue.main.async {
                    block(indexPath, image)
                }
            }
            
            // epmty the blocks array after returning and caching the image
            self.loadingResponses[url]?.removeAll()
            self.loadingResponses[url] = nil
            
        }).resume()

        
    }
        
}
