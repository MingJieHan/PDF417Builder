//
//  ViewController.m
//  PDF417
//
//  Created by Han Mingjie on 2020/9/2.
//  Copyright © 2020 MingJie Han. All rights reserved.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
@interface ViewController ()<UITextViewDelegate>{
    UITextView *textView;
    UIImageView *imageView;
}

@end

@implementation ViewController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (nil == textView){
        textView = [[UITextView alloc] initWithFrame:CGRectMake(5.f, 130.f, self.view.frame.size.width-10.f, 100.f)];
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
        textView.text = @"1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        textView.delegate = self;
        [self.view addSubview:textView];
    }
    if (nil == imageView){
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 20.f, self.view.frame.size.width-20.f, 100.f)];
        [self.view addSubview:imageView];
    }
    if (nil == imageView.image){
        [self build];
    }
}

-(void)build{
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIPDF417BarcodeGenerator"];
    [ciFilter setDefaults];
    NSData *data = [textView.text dataUsingEncoding:NSUTF8StringEncoding];
    [ciFilter setValue:data forKey:@"inputMessage"];
    [ciFilter setValue:@"H" forKey:@"inputCorrectionLevel"]; // L: low, M: Medium, Q: Quartile, H: High

    // Create the image at the desired size
    CGSize size = CGSizeMake(480, 480);
    CGRect rect = CGRectIntegral(ciFilter.outputImage.extent);
    CIImage *ciImage = [ciFilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(size.width/CGRectGetWidth(rect), size.height/CGRectGetHeight(rect))];
    imageView.image = [UIImage imageWithCIImage:ciImage];
    [imageView setFrame:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height)];
    [imageView setCenter:CGPointMake(self.view.frame.size.width/2.f, 80.f)];
}

#pragma mark - TextDelegate
- (void)textViewDidEndEditing:(UITextView *)textView{
    [self build];
}
- (void)textViewDidChange:(UITextView *)textView{
    [self build];
    return;
}
@end


