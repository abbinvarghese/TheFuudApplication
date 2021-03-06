//
//  TFAFeedbackViewController.m
//  TheFuudApplication
//
//  Created by Abbin Varghese on 20/06/16.
//  Copyright © 2016 Abbin Varghese. All rights reserved.
//

#import "TFAFeedbackViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@import Firebase;

@interface TFAFeedbackViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)NSMutableArray *messages;
@property (nonatomic, strong)JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (nonatomic, strong)JSQMessagesBubbleImage *incomingBubbleImageView;

@end

@implementation TFAFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        if (user.isAnonymous) {
            self.senderId = user.uid;
            self.senderDisplayName = @"";
        }
        else{
            for (id<FIRUserInfo> profile in user.providerData) {
                self.senderId = user.uid;
                self.senderDisplayName = profile.displayName;
            }
        }
    }
    
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    _outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleBlueColor]];
    _incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    [self observeMessages];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - JSQMessages DataSourse -


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.messages count];
}

-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _messages[indexPath.item];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessage *message = _messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        return _outgoingBubbleImageView;
    }
    else{
        return _incomingBubbleImageView;
    }
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *message = _messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else{
        cell.textView.textColor = [UIColor blackColor];
    }
    return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - JSQMessages Delegate -


- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date{
    FIRDatabaseReference *ref = [[FIRDatabase database] reference];
    
    NSString *key = [[ref child:messagesPathKey] childByAutoId].key;
    NSDictionary *post = [NSDictionary dictionaryWithObjectsAndKeys:
                          text,feedbackTextKey,
                          senderId,userIDKey, nil];
    
    NSDictionary *childUpdates = @{[@"/users/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",senderId,messagesPathKey,key]]: post,
                                   [@"/feedbacks/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@",senderId,key]]: post};
    
    [ref updateChildValues:childUpdates];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage, nil];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - UIImagePickerController Delegate -


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSURL *videoUrl=(NSURL*)[info objectForKey:UIImagePickerControllerMediaURL];
         NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
        
        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"%@feedback/%@",storagePathKey,[self uuid]]];
        
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"video/mov";
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        FIRStorageUploadTask *uploadTask = [storageRef putData:videoData metadata:metadata];
        
        [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
            double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
            NSLog(@"%f",percentComplete);
        }];
        
        [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
            
            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
            
            NSString *key = [[ref child:messagesPathKey] childByAutoId].key;
            NSDictionary *post = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"",feedbackTextKey,
                                  self.senderId,userIDKey,
                                  [NSString stringWithFormat:@"%@",snapshot.metadata.downloadURL],feedbackFileURLKey,nil];
            
            NSDictionary *childUpdates = @{[@"/users/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@/%@",self.senderId,messagesPathKey,key]]: post,
                                           [@"/feedbacks/" stringByAppendingString:[NSString stringWithFormat:@"%@/%@",self.senderId,key]]: post};
            
            [ref updateChildValues:childUpdates];
            
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            
            [self finishSendingMessage];
            
        }];
        
        // Errors only occur in the "Failure" case
        [uploadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (snapshot.error != nil) {
                switch (snapshot.error.code) {
                    case FIRStorageErrorCodeObjectNotFound:
                        // File doesn't exist
                        break;
                        
                    case FIRStorageErrorCodeUnauthorized:
                        // User doesn't have permission to access file
                        break;
                        
                    case FIRStorageErrorCodeCancelled:
                        // User canceled the upload
                        break;
                        
                    case FIRStorageErrorCodeUnknown:
                        // Unknown error occurred, inspect the server response
                        break;
                }
            }
        }];
        
    }else if (CFStringCompare ((__bridge CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo){
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        FIRStorageReference *storageRef = [[FIRStorage storage] referenceForURL:[NSString stringWithFormat:@"%@feedback/%@",storagePathKey,[self uuid]]];
        
        FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
        metadata.contentType = @"image/jpeg";
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        FIRStorageUploadTask *uploadTask = [storageRef putData:imageData metadata:metadata];
        
        [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
            double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
            NSLog(@"%f",percentComplete);
        }];
        
        [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
            
            FIRDatabaseReference *ref = [[FIRDatabase database] reference];
            
            NSString *key = [[ref child:messagesPathKey] childByAutoId].key;
            NSDictionary *post = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"",feedbackTextKey,
                                  self.senderId,userIDKey,
                                  [NSString stringWithFormat:@"%@",snapshot.metadata.downloadURL],feedbackFileURLKey,nil];
            
            NSDictionary *childUpdates = @{[NSString stringWithFormat:@"/%@/%@/%@/%@",userPathKey,self.senderId,messagesPathKey,key]: post,
                                           [NSString stringWithFormat:@"/%@/%@/%@",feedbackPathKey,self.senderId,key]: post};
            
            [ref updateChildValues:childUpdates];
            
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            
            [self finishSendingMessage];
            
        }];
        
        // Errors only occur in the "Failure" case
        [uploadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
            if (snapshot.error != nil) {
                switch (snapshot.error.code) {
                    case FIRStorageErrorCodeObjectNotFound:
                        // File doesn't exist
                        break;
                        
                    case FIRStorageErrorCodeUnauthorized:
                        // User doesn't have permission to access file
                        break;
                        
                    case FIRStorageErrorCodeCancelled:
                        // User canceled the upload
                        break;
                        
                    case FIRStorageErrorCodeUnknown:
                        // Unknown error occurred, inspect the server response
                        break;
                }
            }
        }];
        
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thank you!" message:@"Your attachment will be uploaded" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - Utility Methods -


-(void)observeMessages{
    FIRDatabaseReference *ref = [[[[[FIRDatabase database] reference] child:userPathKey] child:self.senderId]child:messagesPathKey];
    [ref keepSynced:YES];
    [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        NSString *sendID = snapshot.value[userIDKey];
        NSString *text = snapshot.value[feedbackTextKey];
        NSString *fileURL = snapshot.value[feedbackFileURLKey];
        [self addMessage:sendID text:text url:fileURL];
        [self finishReceivingMessage];
    }];
}

-(void)addMessage:(NSString*)sendID text:(NSString*)text url:(NSString*)url{
    if (url == nil) {
        JSQMessage *messages = [JSQMessage messageWithSenderId:sendID displayName:@"" text:text];
        
        [JSQMessage messageWithSenderId:@"" displayName:@"" text:text];
        if (_messages == nil) {
            _messages = [NSMutableArray new];
        }
        [_messages addObject:messages];
    }
}

- (NSString *)uuid{
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    return (__bridge_transfer NSString *)uuidStringRef;
}

- (IBAction)dismiss:(UIBarButtonItem *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
