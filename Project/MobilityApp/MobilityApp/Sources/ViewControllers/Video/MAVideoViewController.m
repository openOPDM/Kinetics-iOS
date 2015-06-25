//
//  MAVideoViewController.m
//  MobilityApp
//
//  Created by Vitaly Yurchenko on 5/13/14.
//  Copyright (c) 2014 Kinetics Foundation. All rights reserved.
//

#import "MAVideoViewController.h"

#import <MediaPlayer/MediaPlayer.h>

@interface MAVideoViewController ()

@property (nonatomic) MPMoviePlayerController *moviePlayerController;

@end

@implementation MAVideoViewController

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:self.fileURL];
    self.moviePlayerController.view.frame = self.view.bounds;
    self.moviePlayerController.controlStyle = MPMovieControlStyleEmbedded;
    self.moviePlayerController.scalingMode = MPMovieScalingModeAspectFit;
    self.moviePlayerController.movieSourceType = MPMovieSourceTypeFile;
    self.moviePlayerController.allowsAirPlay = YES;
    
    [self.view addSubview:self.moviePlayerController.view];
    
    [self.moviePlayerController play];
}

@end
