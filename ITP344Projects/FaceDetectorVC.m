//
//  FaceDetectorVC.m
//  ITP344Projects
//
//  Created by David Richardson on 2/18/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "FaceDetectorVC.h"

@interface FaceDetectorVC(){
 
    NSArray *imageLinks;
    NSMutableArray *imageArray;
    NSMutableArray *numFaces;
    UIBackgroundTaskIdentifier bTask;
    
}

@end

@implementation FaceDetectorVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadLinks];
    
}

- (void)loadLinks {
    
    imageLinks =  @[@"https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg",
                    
                    @"http://img2.tvtome.com/i/u/28c79aac89f44f2dcf865ab8c03a4201.png",
                    @"http://news.brown.edu/files/article_images/MarsRover1.jpg",
                    @"https://loveoffriends.files.wordpress.com/2012/02/love-of-friends-117.jpg",
                    @"http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
                    @"http://www.facultyfocus.com/wp-content/uploads/images/iStock_000012443270Large150921.jpg",
                    @"http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
                    @"http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
                    @"http://www.ymcanyc.org/i/ADULTS%20groupspinning2%20FC.jpg",
                    @"http://www.dogslovewagtime.com/wp-content/uploads/2015/07/Dog-Pictures.jpg",
                    @"http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"];
    
}

- (void)beginDownloads {
    
    
    imageArray = [[NSMutableArray alloc] init];
    numFaces = [[NSMutableArray alloc] init];
    
    // asynchronous background call
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        // background task expiration
        bTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            [[UIApplication sharedApplication] endBackgroundTask:bTask];
            bTask = UIBackgroundTaskInvalid;
            
        }];
        
        // iterate over downloads
        for(int i = 0; i < [imageLinks count]; i++){
            
            NSString *imageUrl = [imageLinks objectAtIndex:i];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            
            // add image to array
            [imageArray addObject:image];
            
            // detect faces
            CIImage* ciImage = [[CIImage alloc] initWithCGImage:image.CGImage];
            
            CIContext *context = [CIContext contextWithOptions:nil];                    // 1
            NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh };      // 2
            CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                      context:context
                                                      options:opts];                    // 3
            
            NSArray *features = [detector featuresInImage:ciImage];        // 5
            
            
            // create string
            NSInteger num = [features count];
            NSString *str;
            
            if(num == 0){
                str = [NSString stringWithFormat:@"No faces detected"];
            } else {
                str = [NSString stringWithFormat:@"%ld face(s) detected", num];
            }
            
            [numFaces addObject:str];
            
            // update ui
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                
                NSArray *indexPaths = @[path];
                
                
                // insert new row
                [self.tableView beginUpdates];
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationRight];
                [self.tableView endUpdates];
                

            });
            
        }
        
    });
    
}

- (IBAction)buttonPressed:(id)sender {
    
    [self beginDownloads];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [imageArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"TableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger row = indexPath.row;
    
    cell.imageView.image = [imageArray objectAtIndex:row];
    
    cell.textLabel.text = [numFaces objectAtIndex:row];
    
    return cell;
}







@end
