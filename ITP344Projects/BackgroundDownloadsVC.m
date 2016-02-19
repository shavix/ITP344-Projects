//
//  BackgroundDownloadsVC.m
//  ITP344Projects
//
//  Created by David Richardson on 2/16/16.
//  Copyright © 2016 David Richardson. All rights reserved.
//

#import "BackgroundDownloadsVC.h"

@interface BackgroundDownloadsVC(){
    
    NSArray *imageLinks;
    NSMutableArray *imageArray;
    UIBackgroundTaskIdentifier bTask;
    
}

@end

@implementation BackgroundDownloadsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self loadImages];
    
    
}

- (void)loadImages {
    
    imageLinks = @[@"https://upload.wikimedia.org/wikipedia/commons/d/d8/NASA_Mars_Rover.jpg",
    
    @"http://www.wired.com/wp-content/uploads/images_blogs/wiredscience/2012/08/Mars-in-95-Rover1.jpg",
    
    @"http://news.brown.edu/files/article_images/MarsRover1.jpg",
    
    @"http://www.nasa.gov/images/content/482643main_msl20100916-full.jpg",
    
    @"https://upload.wikimedia.org/wikipedia/commons/f/fa/Martian_rover_Curiosity_using_ChemCam_Msl20111115_PIA14760_MSL_PIcture-3-br2.jpg",
    
    @"http://mars.nasa.gov/msl/images/msl20110602_PIA14175.jpg",
    
    @"http://i.kinja-img.com/gawker-media/image/upload/iftylroaoeej16deefkn.jpg",
    
    @"http://www.nasa.gov/sites/default/files/thumbnails/image/journey_to_mars.jpeg",
    
    @"http://i.space.com/images/i/000/021/072/original/mars-one-colony-2025.jpg?1375634917",
    
    @"http://cdn.phys.org/newman/gfx/news/hires/2015/earthandmars.png"];
    
}

- (void)beginDownloads {
    
    
    // asynchronous dispatch queue
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        imageArray = [[NSMutableArray alloc] init];
        
        // background task expiration
        bTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
            [[UIApplication sharedApplication] endBackgroundTask:bTask];
            bTask = UIBackgroundTaskInvalid;
            
        }];
        
        
        // iterate over downloads
        for(int i = 0; i < [imageLinks count]; i++){
            
            NSString *imageUrl = [imageLinks objectAtIndex:i];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
            
            // simulate stalling
            //[NSThread sleepForTimeInterval:3];
            
            // add image to array
            [imageArray addObject:image];

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
    
    cell.textLabel.text = [imageLinks objectAtIndex:row];
    
    return cell;
}


@end
