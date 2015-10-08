//
//  AddPicNoteViewController.m
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "AddPicNoteViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PicTodoDB.h"

@interface AddPicNoteViewController () {
    UIImagePickerController *imagePicker;
    NSString *fileName;
    PicTodoDB *picTodoDB;
}

@end

@implementation AddPicNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"添加图片";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar3.png"];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.cornerRadius = 10.0f;
    self.imageView.layer.borderColor = [[UIColor greenColor]CGColor];
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.alpha = 0.7;
    self.textView.layer.cornerRadius = 10.0f;
    self.textView.layer.borderColor = [[UIColor redColor]CGColor];
    self.textView.layer.borderWidth = 1.0f;
    self.textView.alpha = 0.5;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnImageView)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapGesture];
    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/pic",NSHomeDirectory()];
    picTodoDB = [[PicTodoDB alloc]initWithFilePath:filePath];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePicList)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [picTodoDB read];
}

- (void)savePicList {
    if (self.imageView.image == nil || [self.textView.text isEqualToString:@""]) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"图片或描述不能为空" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
    }else {
        NSData *data = UIImageJPEGRepresentation(self.imageView.image, 0.5);
        PicTodo *newTodo = [[PicTodo alloc]initWithImage:data andDescription:self.textView.text];
        [picTodoDB addTodo:newTodo withName:fileName];
        [self saveImage:self.imageView.image toPath:fileName];
        [picTodoDB write];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"保存成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)tapOnImageView {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"添加照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册添加",@"相机拍摄", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相册不可用" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            break;
        case 1:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"相机不可用" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
            break;
            
        default:
            break;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        if (representation) {
            fileName = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),[representation filename]];
        }else {
            NSDate *now = [NSDate date];
            NSDateFormatter *fm = [[NSDateFormatter alloc]init];
            [fm setDateFormat:@"yyyyMMddHHmm"];
            fileName = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),[fm stringFromDate:now]];
        }
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc]init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    self.imageView.image = image;
    
    [self.imageLabel setHidden:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image toPath:(NSString *)path {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [imageData writeToFile:path atomically:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.3];
    [self.view setTransform:CGAffineTransformMakeTranslation(0, -150)];
    [UIView commitAnimations];
    [self.textLabel setHidden:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.textView.text length] == 0) {
        [self.textLabel setHidden:NO];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.2];
    [self.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
    if ([self.textView.text length] == 0) {
        [self.textLabel setHidden:NO];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}
@end
