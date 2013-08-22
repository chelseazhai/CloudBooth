//
//  ExhibitDetailInfoViewController.m
//  CloudBooth
//
//  Created by Ares on 13-8-18.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ExhibitDetailInfoViewController.h"

// http request utils
#import "HttpReqUtils.h"

// exhibit detail info object
#import "ExhibitDetailInfoBean.h"

// exhibit detail info file info object
#import "ExhibitFileInfoBean.h"

// exhibit detail info function view
#import "ExhibitDetailInfoFunctionView.h"

// exhibit file view controller
#import "ExhibitFileViewController.h"

// rows in thumbnail section
#define ROWSINTHUMBNAILSECTION   1

// function button item shown and hidden tag
#define FUNCTIONBUTTONITEM_HIDDENTAG    0
#define FUNCTIONBUTTONITEM_SHOWNTAG 1

@interface ExhibitDetailInfoViewController ()

// back to content table view controller flag
@property (nonatomic, readwrite) BOOL backToContentTableViewController;

// number of section
@property (nonatomic, readwrite) NSUInteger numberOfSections;

// exhibit detail info object
@property (nonatomic, retain) ExhibitDetailInfoBean *exhibitDetailInfo;

// exhibit detail info file list
@property (nonatomic, retain) NSMutableArray *exhibitFileList;

// done get exhibit detail info
- (void)doneGetExhibitDetailInfo;

// exhibit detail info function view
@property (nonatomic, retain) ExhibitDetailInfoFunctionView *functionView;

// done check exhibit detail info can or can't collect
- (void)doneCheckExhibitDetailInfoCanCollect;

// handle gesture
- (void)handleGesture:(UIGestureRecognizer*)gestureRecognizer;

// show or hide function view
- (void)show6HideFunctionView:(UIBarButtonItem *)functionButtonItem;

@end

@implementation ExhibitDetailInfoViewController

- (id)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // hide bottom tab bar when exhibit detail info view controller been pushed
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // init swipe left and right gesture recognizer
    UISwipeGestureRecognizer *_swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    UISwipeGestureRecognizer *_swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    
    // set direction
    _swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    _swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    // add swipe left and right gesture recognizer to table view
    [self.tableView addGestureRecognizer:_swipeLeftGestureRecognizer];
    [self.tableView addGestureRecognizer:_swipeRightGestureRecognizer];
    
    // get exhibit detail info
    // define get exhibit detail info request param dictionary
    NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
    
    // set param key and value
    [_paramDic setObject:NSRBGServerFieldString(@"get document detail info post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
    [_paramDic setObject:_exhibitDocId forKey:NSRBGServerFieldString(@"post http request param key document id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
    
    // send get exhibit detail info asynchronous post http request
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
                        // save exhibit detail info object
                        _exhibitDetailInfo = [ExhibitDetailInfoBean objectFromJSONData:[[data objectFromJSONData] objectAtIndex:0] thumbnails:gImgUrlImageDictionary];
                        
                        // add thumbnail section
                        _numberOfSections += 2;
                        
                        // done get exhibit detail info
                        [self performSelectorOnMainThread:@selector(doneGetExhibitDetailInfo) withObject:nil waitUntilDone:NO];
                        
                        break;
                        
                    default:
                        NSLog(@"Get exhibit detail info failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        //
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send get exhibit detail info request response not a http response");
            }
        }
        else {
            NSLog(@"Send get exhibit detail info http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set back to content table view controller flag is true
    _backToContentTableViewController = YES;
    
    // hide bottom toolbar
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // check function view and its parent view
    if (nil != _functionView && ![self.tableView.superview.subviews containsObject:_functionView]) {
        // add exhibit detail info function view as subview of table view parent view and send to back
        [self.tableView.superview addSubview:_functionView];
        [self.tableView.superview sendSubviewToBack:_functionView];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // check back to content table view controller flag
    if (YES == _backToContentTableViewController) {
        // check function view and exhibit session id
        if (nil != _functionView && nil != _functionView.exhibitSessionId) {
            NSLog(@"You need to cancel exhibit the document, force excute!");
            
            // force cancel exhibit the document
            [_functionView forceCancelExhibit];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0 == section ? ROWSINTHUMBNAILSECTION : 1 == section ? 0 : [_exhibitFileList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Return the title of header in the section.
    return 0 == section ? [NSString stringWithFormat:NSLocalizedString(@"exhibit detail info tag format string", nil), _exhibitDetailInfo.tagString] : 1 == section ?  [NSString stringWithFormat:NSLocalizedString(@"exhibit detail info content format string", nil), _exhibitDetailInfo.content] : NSLocalizedString(@"exhibit detail info file list tip string", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = 0 == indexPath.section ? @"Exhibit detail info thumbnail view cell" : @"Exhibit detail info file list view cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            // set selection type
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // set background view and its content mode
            cell.backgroundView = [[UIImageView alloc] initWithImage:_exhibitDetailInfo.thumbnail];
            cell.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
            
            break;
            
        case 1:
            // nothing to do
            
            break;
            
        case 2:
            // set accessory type
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            // get file info bean
            ExhibitFileInfoBean *_fileInfo = [ExhibitFileInfoBean objectFromJSONData:[_exhibitFileList objectAtIndex:indexPath.row]];
            
            // set file type icon as image view image and file name as text label text
            cell.imageView.image = _fileInfo.fileTypeIcon;
            cell.textLabel.text = _fileInfo.name;
            
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // content table view cell height
    return 0 == indexPath.section ? _exhibitDetailInfo.thumbnail.size.height * (tableView.bounds.size.width / _exhibitDetailInfo.thumbnail.size.width) : tableView.rowHeight;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *_ret = indexPath;
    
    // exhibit detail info thumbnail couldn't be selected
    if (_numberOfSections - 1 != indexPath.section) {
        _ret = nil;
    }
    else {
        // check right bar button item(function button item) tag
        if (FUNCTIONBUTTONITEM_SHOWNTAG == self.navigationItem.rightBarButtonItem.tag) {
            // deselect the row
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            _ret = nil;
        }
    }
    
    return _ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // set back to content table view controller flag is false
    _backToContentTableViewController = NO;
    
    // define exhibit file view controller
    ExhibitFileViewController *_exhibitFileViewController = [[ExhibitFileViewController alloc] initWithNibName:nil bundle:nil];
    
    // pass the selected exhibit session id, QR image, index of all neighbour file list and all neighbour file list to the view controller
    if (nil != _functionView && nil != _functionView.exhibitSessionId && nil != _functionView.exhibitQRImage) {
        _exhibitFileViewController.exhibitSessionId = _functionView.exhibitSessionId;
        _exhibitFileViewController.exhibitQRImage = _functionView.exhibitQRImage;
    }
    _exhibitFileViewController.exhibitFileIndexOfAllNeighbourFileList = indexPath.row;
    _exhibitFileViewController.exhibitAllNeighbourFileList = _exhibitFileList;
    
    // navigation to exhibit file view controller
    [self.navigationController pushViewController:_exhibitFileViewController animated:YES];
}

#pragma mark - Inner extension

- (void)doneGetExhibitDetailInfo
{
    // set exhibit detail info navigation bar title
    self.title = _exhibitDetailInfo.title;
    
    // save exhibit document id
    _exhibitDetailInfo.id = _exhibitDocId;
    
    // reload data
    [self.tableView reloadData];
    
    // check exhibit detail info can or can't collect
    // define request url
    NSURL *_requestUrl = [NSURL URLWithString:[NSString stringWithFormat:NSUrlString(@"data servlet url format", nil), NSUrlString(@"remote background server root url", nil)]];
    
    // define check exhibit detail info can or can't collect request param dictionary
    NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
    
    // set param key and value
    [_paramDic setObject:NSRBGServerFieldString(@"get favorite list post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
    [_paramDic setObject:_exhibitDocId forKey:NSRBGServerFieldString(@"post http request param key document id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
    
    // send check exhibit detail info can or can't collect asynchronous post http request
    [NSURLConnection sendAsynchronousRequest:[HttpReqUtils genAsyncPostHttpRequest:_requestUrl postParam:_paramDic] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * response, NSData *data, NSError *error) {
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
                        if (nil == data || 0 == [[data objectFromJSONData] count]) {
                            _exhibitDetailInfo.canCollect = YES;
                        }
                        
                        // init exhibit detail info function view
                        [self performSelectorOnMainThread:@selector(doneCheckExhibitDetailInfoCanCollect) withObject:nil waitUntilDone:NO];
                        
                        break;
                        
                    default:
                        NSLog(@"Check exhibit detail info can or can't collect failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        //
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send check exhibit detail info can or can't collect request response not a http response");
            }
        }
        else {
            NSLog(@"Send check exhibit detail info can or can't collect http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
    
    // get exhibit detail info file list
    // redefine get exhibit detail info file list request param dictionary
    _paramDic = [[NSMutableDictionary alloc] init];
    
    // set param key and value
    [_paramDic setObject:NSRBGServerFieldString(@"get document detail info file list post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
    [_paramDic setObject:_exhibitDocId forKey:NSRBGServerFieldString(@"post http request param key document id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
    [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
    
    // send get exhibit detail info file list asynchronous post http request
    [NSURLConnection sendAsynchronousRequest:[HttpReqUtils genAsyncPostHttpRequest:_requestUrl postParam:_paramDic] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // check the error
        if (nil == error) {
            // check the response
            if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
                // get http response
                NSHTTPURLResponse *_httpResponse = (NSHTTPURLResponse *)response;
                
                // get and check http response status code
                switch (_httpResponse.statusCode) {
                    case 200:
                        // reload exhibit detail info file list
                        if (nil == _exhibitFileList) {
                            _exhibitFileList = [[NSMutableArray alloc] init];
                        }
                        else if (0 != _exhibitFileList.count) {
                            [_exhibitFileList removeAllObjects];
                        }
                        [_exhibitFileList addObjectsFromArray:[data objectFromJSONData]];
                        
                        // save exhibit file list
                        _exhibitDetailInfo.fileList = _exhibitFileList;
                        
                        // add exhibit detail info file list section
                        _numberOfSections++;
                        
                        // reload table view data source
                        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                        
                        break;
                        
                    default:
                        NSLog(@"Get exhibit detail info file list failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        //
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send get exhibit detail info file list request response not a http response");
            }
        }
        else {
            NSLog(@"Send get exhibit detail info file list http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
}

- (void)doneCheckExhibitDetailInfoCanCollect
{
    // set fuction button item in the navigation bar as right bar button item
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_functionButtonItem"] style:UIBarButtonItemStylePlain target:self action:@selector(show6HideFunctionView:)];
    
    // init exhibit detail info function view
    _functionView = [[ExhibitDetailInfoFunctionView alloc] initWithDetailInfo:_exhibitDetailInfo parentView:self.tableView.superview];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer
{
    // check gesture recognizer
    if ([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        // check swipe direction
        if (UISwipeGestureRecognizerDirectionLeft == ((UISwipeGestureRecognizer *)gestureRecognizer).direction) {
            // from right to left
            // check right bar button item(function button item) tag
            if (FUNCTIONBUTTONITEM_HIDDENTAG == self.navigationItem.rightBarButtonItem.tag) {
                // show function view
                [self show6HideFunctionView:self.navigationItem.rightBarButtonItem];
            }
        }
        else if (UISwipeGestureRecognizerDirectionRight == ((UISwipeGestureRecognizer *)gestureRecognizer).direction) {
            // from left to right
            // check right bar button item(function button item) tag
            if (FUNCTIONBUTTONITEM_SHOWNTAG == self.navigationItem.rightBarButtonItem.tag) {
                // hide function view
                [self show6HideFunctionView:self.navigationItem.rightBarButtonItem];
            }
        }
    }
    else {
        NSLog(@"Unrecognize gesture recognizer = %@", gestureRecognizer);
    }
}

- (void)show6HideFunctionView:(UIBarButtonItem *)functionButtonItem
{
    // check function view
    if (nil != _functionView) {
        // get and check function button item tag
        if (FUNCTIONBUTTONITEM_HIDDENTAG == functionButtonItem.tag) {
            // show function view
            //self.navigationController.view.center = CGPointMake(self.navigationController.view.center.x - _functionView.width, self.navigationController.view.center.y);
            
            // show function view using animation
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            self.navigationController.navigationBar.center = CGPointMake(self.navigationController.navigationBar.center.x - _functionView.width, self.navigationController.navigationBar.center.y);
            self.tableView.center = CGPointMake(self.tableView.center.x - _functionView.width, self.tableView.center.y);
            
            [UIView commitAnimations];
            
            // set function button item shown tag
            functionButtonItem.tag = FUNCTIONBUTTONITEM_SHOWNTAG;
        }
        else {
            // hide function view
            //self.navigationController.view.center = CGPointMake(self.navigationController.view.center.x + _functionView.width, self.navigationController.view.center.y);
            
            // hide function view using animation
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            self.navigationController.navigationBar.center = CGPointMake(self.navigationController.navigationBar.center.x + _functionView.width, self.navigationController.navigationBar.center.y);
            self.tableView.center = CGPointMake(self.tableView.center.x + _functionView.width, self.tableView.center.y);
            
            [UIView commitAnimations];
            
            // set function button item hidden tag
            functionButtonItem.tag = FUNCTIONBUTTONITEM_HIDDENTAG;
        }
    }
}

@end
