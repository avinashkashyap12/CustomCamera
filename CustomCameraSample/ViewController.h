//
//  ViewController.h
//  CustomCameraSample
//
//  Created by Avinash Kashyap on 7/24/15.
//  Copyright (c) 2015 Avinash Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, weak) IBOutlet UIButton *captureButton;
@property (nonatomic, weak) IBOutlet UIButton *swapButton;
@property (nonatomic, weak) IBOutlet UIView *PreviewView;
-(IBAction) captureButtonAction:(id)sender;
-(IBAction) changeCameraAction:(id)sender;
@end

