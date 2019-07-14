//
//  RecordView.swift
//  WannaBasket
//
//  Created Het Song on 14/07/2019.
//  Copyright © 2019 Het Song. All rights reserved.
//

import UIKit

class RecordView: UIViewController {

	var presenter: RecordPresenterProtocol?
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet { scrollView.contentSize = scrollView.bounds.size }
    }
    
    deinit { print( "Deinit: ", self) }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    @IBAction func saveButtonTapped() {
        presenter?.didTapSaveButton()
    }
    
    @IBAction func backButtonTapped() {
        presenter?.didTapBackButton()
    }
    
    @IBAction func exitButtonTapped() {
        presenter?.didTapExitButton()
    }
}

extension RecordView: RecordViewProtocol {
    
    func saveImageToAlbum() {
        if let image = scrollView.toImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
    }
}
