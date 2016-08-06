//
//  ViewController.m
//  CustomCameraSample
//
//  Created by Avinash Kashyap on 7/24/15.
//  Copyright (c) 2015 Avinash Kashyap. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self inilializeSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//Hide status bar
-(BOOL)prefersStatusBarHidden{
    return YES;
}
#pragma mark -
-(void) inilializeSession{
    //Initialize session
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    //Initialize input capture decise
    self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    if ( [self.session canAddInput:self.captureDeviceInput] )
        //add capture device to session
        [self.session addInput:self.captureDeviceInput];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self view] layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:CGRectMake(0, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
    [self.PreviewView.layer insertSublayer:previewLayer atIndex:0];
    
    AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    if ([self.session canAddOutput:stillImageOutput])
    {
        [stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [self.session addOutput:stillImageOutput];
        [self setStillImageOutput:stillImageOutput];
    }
    
    [self.session startRunning];
}
-(IBAction)captureButtonAction:(id)sender{
    //capture preview image
    [[self stillImageOutput] captureStillImageAsynchronouslyFromConnection:[[self stillImageOutput] connectionWithMediaType:AVMediaTypeVideo] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (imageDataSampleBuffer)
        {
            //get image data from buffer
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
        //save image to photo library
            [[[ALAssetsLibrary alloc] init] writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:nil];
        }
    }];
}
#pragma mark -
-(IBAction) changeCameraAction:(id)sender{
    //disable button
    self.captureButton.enabled = NO;
    self.swapButton.enabled = NO;
    //get current input device
    AVCaptureDevice *currentDevice = self.captureDeviceInput.device;
    AVCaptureDevicePosition preferredPosion = AVCaptureDevicePositionUnspecified;
    AVCaptureDevicePosition currentPosition = currentDevice.position
    ;
    //get new preferred position
    switch (currentPosition) {
        case AVCaptureDevicePositionUnspecified:
            break;
        case AVCaptureDevicePositionBack:
            preferredPosion = AVCaptureDevicePositionFront;
            break;
        case AVCaptureDevicePositionFront:
            preferredPosion = AVCaptureDevicePositionBack;
            break;
    }//end switch case
    //configure new input device
    AVCaptureDevice *captureDevice = [self deviceWithMediaType:AVMediaTypeVideo withPreferredPosition:preferredPosion];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    //update session
    [self.session beginConfiguration];
    // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
    [self.session removeInput:self.captureDeviceInput];
    
    if ( [self.session canAddInput:deviceInput] ) {
        
        [self.session addInput:deviceInput];
        self.captureDeviceInput = deviceInput;
    }
    else {
        [self.session addInput:self.captureDeviceInput];
    }
    [self.session commitConfiguration];
    //enable button
    self.captureButton.enabled = YES;
    self.swapButton.enabled = YES;
}
-(AVCaptureDevice *) deviceWithMediaType:(NSString *)mediaType withPreferredPosition:(AVCaptureDevicePosition) position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    return captureDevice;
}
@end

