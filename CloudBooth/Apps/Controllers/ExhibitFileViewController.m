//
//  ExhibitFileViewController.m
//  CloudBooth
//
//  Created by Ares on 13-8-19.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ExhibitFileViewController.h"

// http request utils
#import "HttpReqUtils.h"

// exhibit detail info file info object
#import "ExhibitFileInfoBean.h"

// navigation bottom tool bar height
#define NAVIGATIONBOTTOMTOOLBAR_HEIGHT  44.0

// bottom toolbar flex button item
#define TOOLBAR_FLEXBUTTONITEM  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]

// bottom toolbar exhibit file previous and next image button item
#define TOOLBAR_FILEPREVIOUSIMAGEBUTTONITEM [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_previousPage"] style:UIBarButtonItemStylePlain target:self action:@selector(presentFilePreviousImage)]
#define TOOLBAR_FILENEXTIMAGEBUTTONITEM [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_nextPage"] style:UIBarButtonItemStylePlain target:self action:@selector(presentFileNextImage)]

// bottom toolbar previous and next exhibit file image button item
#define TOOLBAR_PREVIOUSFILEIMAGEBUTTONITEM [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_previousFile"] style:UIBarButtonItemStylePlain target:self action:@selector(presentPreviousFileImage)]
#define TOOLBAR_NEXTFILEIMAGEBUTTONITEM [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_nextFile"] style:UIBarButtonItemStylePlain target:self action:@selector(presentNextFileImage)]

@interface ExhibitFileViewController ()

// exhibit QR image button item clicked
- (void)exhibitQRImageButtonItemClicked:(UIBarButtonItem *)exhibitQRImageButtonItem;

// exhibit file info object
@property (nonatomic, retain) ExhibitFileInfoBean *exhibitFileInfo;

// exhibit file id
@property (nonatomic, retain) NSString *exhibitFileId;

// exhibit file present web view
@property (nonatomic, retain) UIWebView *filePresentWebView;

// send get exhibit detail info file image post http request
- (void)sendGetExhibitFileImageAsyncPostHttpRequest;

// exhibit file image index
@property (nonatomic, readwrite) NSUInteger fileImageIndex;

// load exhibit file image with index using file present web view
- (void)loadExhibitFileImage:(NSUInteger)index;

// left, middle and right toolbar button items
@property (nonatomic, retain) UIBarButtonItem *leftToolbarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *middleToolbarButtonItem;
@property (nonatomic, retain) UIBarButtonItem *rightToolbarButtonItem;

// reload bottom toolbar items
- (void)reloadToolbarItems;

// present exhibit file previous and next image
- (void)presentFilePreviousImage;
- (void)presentFileNextImage;

// present previous and next exhibit file first image
- (void)presentPreviousFileImage;
- (void)presentNextFileImage;

@end

@implementation ExhibitFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // check exhibit QR image
    if (nil != _exhibitQRImage) {
        // set exhibit QR image button item in the navigation bar as right bar button item
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_qrButtonItem"] style:UIBarButtonItemStylePlain target:self action:@selector(exhibitQRImageButtonItemClicked:)];
    }
    
    // init file present webview
    _filePresentWebView = [[UIWebView alloc] init];
    
    // set frame
    [_filePresentWebView setFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height - NAVIGATIONBAR_HEIGHT - NAVIGATIONBOTTOMTOOLBAR_HEIGHT)];
    
    // set delegate
    _filePresentWebView.delegate = self;
    
    // add as subview of exhibit file view controller
    [self.view addSubview:_filePresentWebView];
	
    // get exhibit detail info file image
    [self sendGetExhibitFileImageAsyncPostHttpRequest];
    
    // show bottom toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - web view delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    // check exhibit session id
    if (nil != _exhibitSessionId) {
        // set notify exhibit file image page
        // define set notify exhibit file image page request param dictionary
        NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
        
        // set param key and value
        [_paramDic setObject:NSRBGServerFieldString(@"set document detail info exhibit file image page post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
        [_paramDic setObject:_exhibitSessionId forKey:NSRBGServerFieldString(@"cancel exhibit document post http request param key session id", nil)];
        [_paramDic setObject:[NSNumber numberWithUnsignedInt:_fileImageIndex] forKey:NSRBGServerFieldString(@"set document detail info exhibit file image page post http request param key image page index", nil)];
        [_paramDic setObject:_exhibitFileId forKey:NSRBGServerFieldString(@"get document detail info file image post http request param key file id", nil)];
        [_paramDic setObject:[[_exhibitAllNeighbourFileList objectAtIndex:_exhibitFileIndexOfAllNeighbourFileList] objectForKey:NSRBGServerFieldString(@"get document detail info file list request response data key document id", nil)] forKey:NSRBGServerFieldString(@"post http request param key document id", nil)];
        [_paramDic setObject:_exhibitFileInfo.type forKey:NSRBGServerFieldString(@"set document detail info exhibit file image page post http request param key file type", nil)];
        [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
        [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
        
        // send set notify exhibit file image page asynchronous post http request
        [NSURLConnection sendAsynchronousRequest:[HttpReqUtils genAsyncPostHttpRequest:[NSURL URLWithString:[NSString stringWithFormat:NSUrlString(@"data servlet url format", nil), NSUrlString(@"remote background server root url", nil)]] postParam:_paramDic] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            // nothing to do
        }];
    }
}

#pragma mark - Inner extension

- (void)exhibitQRImageButtonItemClicked:(UIBarButtonItem *)exhibitQRImageButtonItem
{
    // define exhibit QR image item
    NSArray *_exhibitQRImageItem = [NSArray arrayWithObject:[KxMenuItem menuItem:nil image:_exhibitQRImage target:nil action:nil]];
    
    // get exhibit QR image button
    UIControl *_exhibitQRImageButton;
    
    // find exhibit QR image button item in navigation bar
    for (UIView *_subview in self.navigationController.navigationBar.subviews) {
        // check subview of navigation bar class type
        if ([_subview isKindOfClass:[UIControl class]]) {
            // check each action target
            for (id _target in [(UIControl *)_subview allTargets]) {
                if (_target == exhibitQRImageButtonItem) {
                    // set exhibit QR image button
                    _exhibitQRImageButton = (UIControl *)_subview;
                    
                    break;
                }
            }
            
            // check exhibit QR image button
            if (nil != _exhibitQRImageButton) {
                // find it, break immediately
                break;
            }
        }
    }
    
    // show more menu as popup menu
    [KxMenu showMenuInView:self.view.window fromRect:CGRectMake(_exhibitQRImageButton.frame.origin.x, _exhibitQRImageButton.frame.size.height - _exhibitQRImageButton.frame.origin.y / 2, _exhibitQRImageButton.frame.size.width, _exhibitQRImageButton.frame.size.height) menuItems:_exhibitQRImageItem];
}

- (void)sendGetExhibitFileImageAsyncPostHttpRequest
{
    // define get exhibit detail info file image request param dictionary
    NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
    
    // get exhibit file info and exhibit file id
    _exhibitFileInfo = [ExhibitFileInfoBean objectFromJSONData:[_exhibitAllNeighbourFileList objectAtIndex:_exhibitFileIndexOfAllNeighbourFileList]];
    _exhibitFileId = [[_exhibitAllNeighbourFileList objectAtIndex:_exhibitFileIndexOfAllNeighbourFileList] objectForKey:NSRBGServerFieldString(@"get document detail info file list request response data key file id", nil)];
    
    // set param key and value
    [_paramDic setObject:NSRBGServerFieldString(@"get document detail info file image post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
    [_paramDic setObject:_exhibitFileId forKey:NSRBGServerFieldString(@"get document detail info file image post http request param key file id", nil)];
    
    // send get exhibit detail info file image asynchronous post http request
    [NSURLConnection sendAsynchronousRequest:[HttpReqUtils genAsyncPostHttpRequest:[NSURL URLWithString:[NSString stringWithFormat:NSUrlString(@"data servlet url format", nil), NSUrlString(@"remote background server root url", nil)]] postParam:_paramDic] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // check the error
        if (nil == error) {
            // check the response
            if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
                // get http response
                NSHTTPURLResponse *_httpResponse = (NSHTTPURLResponse *)response;
                
                // get and check http response status code
                switch (_httpResponse.statusCode) {
                    case 200:
                        // check response data
                        if (nil != data && 0 < [[data objectFromJSONData] count]) {
                            // save exhibit file info object number of images
                            _exhibitFileInfo.numberOfImages = ((NSString *)[[[data objectFromJSONData] objectAtIndex:0] objectForKey:NSRBGServerFieldString(@"get document detail info file image request response data key number of images", nil)]).integerValue;
                        }
                        
                        // set exhibit file navigation bar title
                        [self performSelectorOnMainThread:@selector(setTitle:) withObject:_exhibitFileInfo.name waitUntilDone:NO];
                        
                        // update exhibit file image index
                        _fileImageIndex = 1;
                        
                        // load toolbar items
                        [self performSelectorOnMainThread:@selector(reloadToolbarItems) withObject:nil waitUntilDone:NO];
                        
                        // load exhibit file first image
                        [self loadExhibitFileImage:_fileImageIndex];
                        
                        break;
                        
                    default:
                        NSLog(@"Get exhibit detail info file image failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        //
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send get exhibit detail info file image request response not a http response");
            }
        }
        else {
            NSLog(@"Send get exhibit detail info file image http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
}

- (void)loadExhibitFileImage:(NSUInteger)index
{
    // check exhibit file type and load file present webview file image url
    [_filePresentWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%u.%@", [NSString stringWithFormat:NSUrlString(@"common image file url format", nil), NSUrlString(@"remote background server root url", nil)], _exhibitFileId, index, _exhibitFileInfo.isVideoMediaFile ? _exhibitFileInfo.type : @"jpg"]]]];
}

- (void)reloadToolbarItems
{
    // check exhibit file index of all neighbour file list
    if (0 == _exhibitFileIndexOfAllNeighbourFileList) {
        // first exhibit file
        _leftToolbarButtonItem = TOOLBAR_FLEXBUTTONITEM;
    }
    if ([_exhibitAllNeighbourFileList count] - 1 == _exhibitFileIndexOfAllNeighbourFileList) {
        // last exhibit file
        _rightToolbarButtonItem = TOOLBAR_FLEXBUTTONITEM;
    }
    if ([_exhibitAllNeighbourFileList count] - 1 > _exhibitFileIndexOfAllNeighbourFileList) {
        // has next exhibit file
        _rightToolbarButtonItem = TOOLBAR_NEXTFILEIMAGEBUTTONITEM;
    }
    if (0 < _exhibitFileIndexOfAllNeighbourFileList && [_exhibitAllNeighbourFileList count] - 1 >= _exhibitFileIndexOfAllNeighbourFileList) {
        // has previous exhibit file
        _leftToolbarButtonItem = TOOLBAR_PREVIOUSFILEIMAGEBUTTONITEM;
    }
    
    // check number of exhibit file images
    if (1 == _exhibitFileInfo.numberOfImages) {
        // no file image page number
        _middleToolbarButtonItem = TOOLBAR_FLEXBUTTONITEM;
    }
    else if (1 < _exhibitFileInfo.numberOfImages) {
        // file image index / number of exhibit file pages
        _middleToolbarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%u / %u", _fileImageIndex, _exhibitFileInfo.numberOfImages] style:UIBarButtonItemStylePlain target:nil action:nil];
        
        // check exhibit file image index
        if (1 == _fileImageIndex) {
            // exhibit file first image
            _rightToolbarButtonItem = TOOLBAR_FILENEXTIMAGEBUTTONITEM;
        }
        if (_exhibitFileInfo.numberOfImages == _fileImageIndex) {
            // exhibit file last image
            _leftToolbarButtonItem = TOOLBAR_FILEPREVIOUSIMAGEBUTTONITEM;
        }
        if (1 <= _fileImageIndex && _exhibitFileInfo.numberOfImages > _fileImageIndex) {
            // exhibit file has next image
            _rightToolbarButtonItem = TOOLBAR_FILENEXTIMAGEBUTTONITEM;
        }
        if (1 < _fileImageIndex && _exhibitFileInfo.numberOfImages >= _fileImageIndex) {
            // exhibit file has previous image
            _leftToolbarButtonItem = TOOLBAR_FILEPREVIOUSIMAGEBUTTONITEM;
        }
    }
    
    // reset bottom toolbar items
    self.toolbarItems = [NSArray arrayWithObjects:TOOLBAR_FLEXBUTTONITEM, _leftToolbarButtonItem, _middleToolbarButtonItem, _rightToolbarButtonItem, TOOLBAR_FLEXBUTTONITEM, nil];
}

- (void)presentFilePreviousImage
{
    // decrease exhibit file image index and load exhibit file previous image
    [self loadExhibitFileImage:--_fileImageIndex];
    
    // reload toolbar items
    [self reloadToolbarItems];
}

- (void)presentFileNextImage
{
    // increase exhibit file image index and load exhibit file next image
    [self loadExhibitFileImage:++_fileImageIndex];
    
    // reload toolbar items
    [self reloadToolbarItems];
}

- (void)presentPreviousFileImage
{
    // decrease exhibit file index of all neighbour file list
    _exhibitFileIndexOfAllNeighbourFileList--;
    
    // get next exhibit file image
    [self sendGetExhibitFileImageAsyncPostHttpRequest];
}

- (void)presentNextFileImage
{
    // increase exhibit file index of all neighbour file list
    _exhibitFileIndexOfAllNeighbourFileList++;
    
    // get next exhibit file image
    [self sendGetExhibitFileImageAsyncPostHttpRequest];
}

@end
