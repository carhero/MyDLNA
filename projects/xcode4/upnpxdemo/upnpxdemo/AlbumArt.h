//
//  AlbumArt.h
//  upnpxdemo
//
//  Created by Cha YoungHoon on 10/21/14.
//  Copyright (c) 2014 Bruno Keymolen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaServer1Device.h"

@interface AlbumArt : UIViewController
{
    NSInteger _SongIdx;
    NSMutableArray *_m_playList;
//    MediaServer1Device *m_device;
}
@property (strong, nonatomic) IBOutlet UIImageView *AlbumeArtView;
//@property (atomic, assign) NSInteger SongIdx;
- (void)setSongIdx:(NSInteger)SongIdxLoc;
- (void)setm_playList:(NSMutableArray*)MediaplayList;

@end