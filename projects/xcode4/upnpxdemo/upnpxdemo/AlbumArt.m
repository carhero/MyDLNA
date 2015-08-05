//
//  AlbumArt.m
//  upnpxdemo
//
//  Created by Cha YoungHoon on 10/21/14.
//  Copyright (c) 2014 Bruno Keymolen. All rights reserved.
//

#import "MediaServerBasicObjectParser.h"
#import "MediaServer1ItemObject.h"
#import "MediaServer1ContainerObject.h"
#import "FolderViewController.h"
#import "PlayBack.h"
#import "AlbumArt.h"


extern NSString *gImageURL;



@interface AlbumArt ()

@end

@implementation AlbumArt

@synthesize AlbumeArtView;
//@synthesize SongIdx = _SongIdx;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [[UIImage alloc]initWithContentsOfFile:@"defaultSong.jpg"];
    
    UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
    imageview.frame = CGRectMake(100, 100, 200, 200);
//    self.AlbumeArtView.image = image;
//    
    [self.view addSubview:imageview];
//    UIImage *albumArtImage = [[UIImage alloc]initWithContentsOfFile:@""];
    NSLog(@"Album Art viewDidLoad is called, self.SongIdx = %ld", _SongIdx);
    
    
    UIImage* myImage = [UIImage imageWithData:
                        [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: (NSString *)gImageURL]]];
    
    self.AlbumeArtView.image = myImage;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)PlayNext:(id)sender {

//    MediaServer1ItemObject *item = m_playList[_SongIdx];
//    MediaServer1ContainerObject *container = _m_playList[_SongIdx];
//    FolderViewController *targetViewController = [[FolderViewController alloc] initWithMediaDevice:m_device andHeader:[container title] andRootId:[container objectID]];
    
    
    
    [[PlayBack GetInstance] Play:_m_playList position:_SongIdx+1];
    _SongIdx += 1;
    
    NSLog(@"PlayNext, %ld",_SongIdx);
}


- (IBAction)PlayPause:(id)sender {
    NSLog(@"PlayPause, %ld",_SongIdx);
    [[PlayBack GetInstance] Play:_m_playList position:_SongIdx];
}

- (IBAction)PlayPrev:(id)sender {
    NSLog(@"PlayPrev,%ld",_SongIdx);
    [[PlayBack GetInstance] Play:_m_playList position:_SongIdx-1];
    _SongIdx -= 1;
}

- (void)setSongIdx:(NSInteger)SongIdxLoc
{
    _SongIdx = SongIdxLoc;
}

- (void)setm_playList:(NSMutableArray*)MediaplayList
{
    if(!_m_playList)
    {
        _m_playList = [[NSMutableArray alloc]init];
    }
    _m_playList = MediaplayList;
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
