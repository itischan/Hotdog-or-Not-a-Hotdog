//
//  ViewController.swift
//  HotdogFinder
//
//  Created by ck on 2023-08-21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    
    
    let imagePicker=UIImagePickerController()
    @IBOutlet var displayImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate=self
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let cameraImage=info[UIImagePickerController.InfoKey.originalImage]as? UIImage{
            displayImage.image=cameraImage
            guard let ciImage=CIImage(image:cameraImage)else{
                fatalError("error retrieving message")
            }
            detect(image: ciImage)
            
        }
        
        
        imagePicker.dismiss(animated: true)
        
            }
    
    
    func detect(image:CIImage){
        
        guard  let model=try? VNCoreMLModel(for: Inceptionv3().model)else{
            fatalError("error")
        }
        let request=VNCoreMLRequest(model: model) { request, error in
            guard let results=request.results as? [VNClassificationObservation]
            else{
                fatalError("eroor")
            }
                        
            if let firstResult=results.first{
                if firstResult.identifier.contains("hotdog"){
                    self.navigationItem.title="It is a hotdog"
                }
                else{
                    self.navigationItem.title="It is not a hotdog"
                }

            }
        }
        let handler=VNImageRequestHandler(ciImage: image)
                    
        do{
            try handler.perform([request])}
        catch{
            print(error)
        }
            
        
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing=false
        
        present(imagePicker, animated: true)
    }
}

