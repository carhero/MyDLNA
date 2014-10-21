//
//  RootViewController.m
//  upnpxdemo
//
//  Created by Bruno Keymolen on 28/05/11.
//  Copyright 2011 Bruno Keymolen. All rights reserved.
//

#import "RootViewController.h"
#import "UPnPManager.h"
#import "FolderViewController.h"
#import "PlayBack.h"

@interface RootViewController() <UPnPDBObserver>

@end

@implementation RootViewController

@synthesize menuView;
@synthesize titleLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuView.dataSource = self;
    self.menuView.delegate = self;
    
    UPnPDB* db = [[UPnPManager GetInstance] DB];
    
    mDevices = [db rootDevices]; //BasicUPnPDevice
    
    [db addObserver:self];
    
    //Optional; set User Agent
    [[[UPnPManager GetInstance] SSDP] setUserAgentProduct:@"upnpxdemo/1.0" andOS:@"OSX"];
    
    
    //Search for UPnP Devices 
    [[[UPnPManager GetInstance] SSDP] searchSSDP];      
    
    self.title = @"My DLNA - Xcode 8";
    self.navigationController.toolbarHidden = NO;


    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0 , 11.0f, self.navigationController.view.frame.size.width, 21.0f)];
    [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0]];
    [self.titleLabel setText:@""];
    [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
    self.titleLabel.textColor = [UIColor redColor];

    UIBarButtonItem *ttitle = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];

    NSArray *items = @[ttitle]; 
    self.toolbarItems = items; 
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mDevices count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    // Configure the cell.
    BasicUPnPDevice *device = mDevices[indexPath.row];
     [[cell textLabel] setText:[device friendlyName]];
    
    BOOL isMediaServer = [device.urn isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"];
    cell.accessoryType = isMediaServer ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    //yhcha adding table view image
    cell.imageView.image = device.smallIcon;
    
    
    NSLog(@"%ld %@", (long)indexPath.row, [device friendlyName]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicUPnPDevice *device = mDevices[indexPath.row];
    
    //yhcha server 일 경우 하위 폴더구조로 이동한다. FolderViewController  class 를 call 한다.
    if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaServer:1"]){
#if 1   //yhcha Test
        MediaServer1Device *server = (MediaServer1Device*)device;
        FolderViewController *targetViewController = [[FolderViewController alloc] initWithMediaDevice:server andHeader:@"Media Server" andRootId:@"0" ];
        [[self navigationController] pushViewController:targetViewController animated:YES];
        [[PlayBack GetInstance] setServer:server];
#else
        
        MediaServer1Device *server = (MediaServer1Device*)device;
        FolderViewController *targetViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AlbumArtPage"];
//        targetViewController = [[FolderViewController alloc]initWithMediaDevice:server andHeader:@"Media Server" andRootId:@"0"];
        [[self navigationController] pushViewController:targetViewController animated:YES];
#endif
    }
    //Media Renderer일 경우의 UITableView의 제알 하단의 바에 글씨를 새긴다.
    else if([[device urn] isEqualToString:@"urn:schemas-upnp-org:device:MediaRenderer:1"]){
        [self.titleLabel setText:[device friendlyName]];
        MediaRenderer1Device *render = (MediaRenderer1Device*)device;
        [[PlayBack GetInstance] setRenderer:render];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


#pragma mark - protocol UPnPDBObserver

-(void)UPnPDBWillUpdate:(UPnPDB*)sender{
    NSLog(@"UPnPDBWillUpdate %lu", (unsigned long)[mDevices count]);
}

-(void)UPnPDBUpdated:(UPnPDB*)sender{
    NSLog(@"UPnPDBUpdated %lu", (unsigned long)[mDevices count]);
    [menuView performSelectorOnMainThread : @ selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
