//
//  CustomView.swift
//  AtlanticCity
//
//  Created by Hamza Arif on 31/03/2020.
//  Copyright © 2020 Hixol. All rights reserved.
//

import UIKit

class CustomView: UIView {
        
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var buttonAction: UIButton!
    @IBOutlet var fav_btn: UIButton!
    @IBOutlet var share_btn: UIButton!
    @IBOutlet var location_lbl: UILabel!
    @IBOutlet var description_lbl: UILabel!
    @IBOutlet var claimed_lbl: UILabel!
    
    var dealsModel : DealsDetail! {
        didSet{
            self.labelText.text = dealsModel.title
            let original = dealsModel.avatar!
            if let encoded = original.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let url = URL(string: encoded)
            {
              let imageView = UIImageView()
              imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                DispatchQueue.main.async {
                    if (downloadImage != nil) {
                    self.imageViewBackground.image = downloadImage!
                    }
                }
              })
            }
            let logolink = dealsModel.business?.logo!
               if let encoded = logolink!.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let url = URL(string: encoded)
             {
               let imageView = UIImageView()
               imageView.kf.setImage(with: url, placeholder: UIImage.init(named: "account_btm"), options: [.transition(.fade(5)),.cacheOriginalImage], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
                 DispatchQueue.main.async {
                    if (downloadImage != nil) {
                    self.imageViewProfile.image = downloadImage!
                    }
                 }
               })
             }
            self.location_lbl.text = dealsModel.business?.address
            self.description_lbl.text = dealsModel.description
//            self.imageViewBackground.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(CustomView.className, owner: self, options: nil)
        contentView.fixInView(self)
        
        imageViewProfile.contentMode = .scaleAspectFill
        imageViewProfile.layer.cornerRadius = 30
        imageViewProfile.clipsToBounds = true
    }
    


}

extension UIView{
    
    func fixInView(_ container: UIView!) -> Void{
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
