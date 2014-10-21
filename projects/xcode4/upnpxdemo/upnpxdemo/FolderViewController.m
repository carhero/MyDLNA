//
//  FolderViewController.m
//  upnpxdemo
//
//  Created by Bruno Keymolen on 02/07/11.
//  Copyright 2011 Bruno Keymolen. All rights reserved.
//

#import "FolderViewController.h"

#import "MediaServerBasicObjectParser.h"
#import "MediaServer1ItemObject.h"
#import "MediaServer1ContainerObject.h"
#import "PlayBack.h"
#import "AlbumArt.h"

//#import "SoapActionsRenderingControl1.h"  //yhcha test


@interface FolderViewController ()
{
    NSArray *imagearray;
}
@end

@implementation FolderViewController

@synthesize titleLabel;

-(id)initWithMediaDevice:(MediaServer1Device*)device andHeader:(NSString*)header andRootId:(NSString*)rootId{
    self = [super init];
    
    if (self) {
        /* TODO: Properties are not retained. Possible issue? */
        m_device = device;
        m_rootId=rootId;
        m_title=header;
        
        m_playList = [[NSMutableArray alloc] init];
    }

    return self;
}




#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Before we do anything, some devices do not support sorting and will fail if we try to sort on our request
    
    NSLog(@"Folder View did load is called");
    NSString *sortCriteria = @"";
    NSMutableString *outSortCaps = [[NSMutableString alloc] init];
    [[m_device contentDirectory] GetSortCapabilitiesWithOutSortCaps:outSortCaps];
    
    if ([outSortCaps rangeOfString:@"dc:title"].location != NSNotFound)
    {
        sortCriteria = @"+dc:title";
    }

    //Allocate NMSutableString's to read the results
    NSMutableString *outResult = [[NSMutableString alloc] init];
    NSMutableString *outNumberReturned = [[NSMutableString alloc] init];
    NSMutableString *outTotalMatches = [[NSMutableString alloc] init];
    NSMutableString *outUpdateID = [[NSMutableString alloc] init];
    
    [[m_device contentDirectory] BrowseWithObjectID:m_rootId BrowseFlag:@"BrowseDirectChildren" Filter:@"*" StartingIndex:@"0" RequestedCount:@"0" SortCriteria:sortCriteria OutResult:outResult OutNumberReturned:outNumberReturned OutTotalMatches:outTotalMatches OutUpdateID:outUpdateID];
//    SoapActionsAVTransport1* _avTransport = [m_device avTransport];
//    SoapActionsConnectionManager1* _connectionManager = [m_device connectionManager];
    
    //The collections are returned as DIDL Xml in the string 'outResult'
    //upnpx provide a helper class to parse the DIDL Xml in usable MediaServer1BasicObject object
    //(MediaServer1ContainerObject and MediaServer1ItemObject)
    //Parse the return DIDL and store all entries as objects in the 'mediaObjects' array
    [m_playList removeAllObjects];
    NSData *didl = [outResult dataUsingEncoding:NSUTF8StringEncoding]; 
    MediaServerBasicObjectParser *parser = [[MediaServerBasicObjectParser alloc] initWithMediaObjectArray:m_playList itemsOnly:NO];
    [parser parseFromData:didl];
    
    
    
    self.navigationController.toolbarHidden = NO;
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, self.navigationController.view.frame.size.width, 21.0f)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0]];
    
    if([[PlayBack GetInstance] renderer] == nil){
        [self.titleLabel setText:@"No Renderer Selected"];        
    }else{
        [self.titleLabel setText:[[[PlayBack GetInstance] renderer] friendlyName] ];
    }
    
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    UIBarButtonItem *ttitle = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    NSArray *items = @[ttitle]; 
    self.toolbarItems = items; 

    
    self.title = m_title;    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_playList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    MediaServer1BasicObject *item = m_playList[indexPath.row];
   [[cell textLabel] setText:[item title]];
    NSLog(@"[item title]:%@", [item title]);
    
    NSLog(@"[item isContainer]:%d", [item isContainer]);
    cell.accessoryType = item.isContainer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    //yhcha test : inserting album art image to uitable view
    
    cell.imageView.image = [UIImage imageNamed:@"defaultSong.jpg"];
    if(item.albumArt != nil)
    {
        NSLog(@"item.albumArt = %@",item.albumArt);
    }
    
//    NSURL *url = [NSURL alloc]initWithString:
#if 0
    //get a dispatch queue
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //this will start the image loading in bg
    dispatch_async(concurrentQueue, ^{
//        NSURL *url = [[NSURL alloc]initWithString:item.albumArt];
        NSData *image = [[NSData alloc] initWithContentsOfFile:item.albumArt];
        
        //this will set the image when loading is finished
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:image];
        });
    });
#endif
    return cell;
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MediaServer1BasicObject *item = m_playList[indexPath.row];
    if([item isContainer]){
        //view sub folder tree
        
        MediaServer1ContainerObject *container = m_playList[indexPath.row];
        FolderViewController *targetViewController = [[FolderViewController alloc] initWithMediaDevice:m_device andHeader:[container title] andRootId:[container objectID]];
        [[self navigationController] pushViewController:targetViewController animated:YES];
    }
    else {
        //Play song and send song stream from server to renderer
#if 0   //yhcha Test (Just Only debug print)
        MediaServer1ItemObject *item = m_playList[indexPath.row];
        MediaServer1ItemRes *resource = nil;		
        NSEnumerator *e = [[item resources] objectEnumerator];
        while((resource = (MediaServer1ItemRes*)[e nextObject])){
            NSLog(@"%@ - %d, %@, %d, %lld, %d, %@", [item title], [resource bitrate], [resource duration], [resource nrAudioChannels], [resource size],  [resource durationInSeconds],  [resource protocolInfo] );
        }	    
#endif
        [[PlayBack GetInstance] Play:m_playList position:indexPath.row];
        
        
        //self에 StoryBoard에 대한 Init이 되어 있지 않았기 때문에 Nil pointer로 page 가 push 되어 나타났던 것이다.
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UpnpxStoryboard" bundle:[NSBundle mainBundle]];
        
        AlbumArt *targetViewController;
        if (targetViewController == nil) {
            targetViewController = [storyboard instantiateViewControllerWithIdentifier:@"AlbumArtPage"];
//            targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumArtPage"];
        }
        [targetViewController setSongIdx:indexPath.row];
        [targetViewController setm_playList:m_playList];
        [[self navigationController] pushViewController:targetViewController animated:YES];
    }
}



@end
