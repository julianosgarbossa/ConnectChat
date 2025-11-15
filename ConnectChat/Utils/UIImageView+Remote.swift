import UIKit
import ObjectiveC
import FirebaseStorage

extension UIImageView {
    
    private static var imageCache = NSCache<NSString, UIImage>()
    private static var urlAssociationKey: UInt8 = 0
    
    private var currentRemoteImageURL: String? {
        get {
            objc_getAssociatedObject(self, &UIImageView.urlAssociationKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.urlAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func setRemoteImage(urlString: String?, placeholder: UIImage? = nil) {
        currentRemoteImageURL = urlString
        
        DispatchQueue.main.async {
            self.image = placeholder
        }
        
        guard let urlString = urlString,
              !urlString.isEmpty,
              let firstComponent = urlString.split(separator: ":").first else {
            return
        }
        
        let cacheKey = urlString as NSString
        
        if let cachedImage = UIImageView.imageCache.object(forKey: cacheKey) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.currentRemoteImageURL == urlString {
                    self.image = cachedImage
                }
            }
            return
        }
        
        if firstComponent == "http" || firstComponent == "https" {
            loadImageFromURLString(urlString, cacheKey: cacheKey)
        } else {
            loadImageFromStoragePath(urlString, cacheKey: cacheKey)
        }
    }
    
    private func loadImageFromURLString(_ urlString: String, cacheKey: NSString) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            guard error == nil, let data = data, let image = UIImage(data: data) else { return }
            
            UIImageView.imageCache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                if self.currentRemoteImageURL == urlString {
                    self.image = image
                }
            }
        }.resume()
    }
    
    private func loadImageFromStoragePath(_ path: String, cacheKey: NSString) {
        let reference = Storage.storage().reference(withPath: path)
        reference.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            guard error == nil, let data = data, let image = UIImage(data: data) else { return }
            
            UIImageView.imageCache.setObject(image, forKey: cacheKey)
            DispatchQueue.main.async {
                if self.currentRemoteImageURL == path {
                    self.image = image
                }
            }
        }
    }
}

