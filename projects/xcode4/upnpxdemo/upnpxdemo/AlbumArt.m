//
//  AlbumArt.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 10/21/14.
//  Copyright (c) 2014 Bruno Keymolen. All rights reserved.
//

#import "AlbumArt.h"

@interface AlbumArt ()

@end

@implementation AlbumArt

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"Album Art viewDidLoad is called");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlayNext:(id)sender {
    NSLog(@"PlayNext");
}


- (IBAction)PlayPause:(id)sender {
    NSLog(@"PlayPause");
}

- (IBAction)PlayPrev:(id)sender {
    NSLog(@"PlayPrev");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
