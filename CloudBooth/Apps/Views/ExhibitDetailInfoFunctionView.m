//
//  ExhibitDetailInfoFunctionView.m
//  CloudBooth
//
//  Created by Ares on 13-8-19.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ExhibitDetailInfoFunctionView.h"

// http request utils
#import "HttpReqUtils.h"

// exhibit detail info function view width
#define WIDTH   270.0

// rows in exhibit url section
#define ROWSINEXHIBITURLSECTION 1

// exhibit QR image height
#define EXHIBITQRIMAGE_HEIGHT   140.0

// core location distance update filter
#define CLDISTANCEUPDATEFILTER  10.0

@interface ExhibitDetailInfoFunctionView ()

// exhibit detail info object
@property (nonatomic, retain) ExhibitDetailInfoBean *exhibitDetailInfo;

// exhibit detail info function operation table view
@property (nonatomic, retain) UITableView *functionOperationTableView;

// number of section
@property (nonatomic, readwrite) NSUInteger numberOfSections;

// operations
@property (nonatomic, retain) NSMutableArray *operations;

// remove operation cell item with indexPath
- (void)removeOperationCellItem:(NSIndexPath *)indexPath;

// core location manager
@property (nonatomic, retain) CLLocationManager *coreLocationManager;

// location coordinate
@property (nonatomic, readwrite) CLLocationCoordinate2D location2DCoordinate;

// done exhibit document
- (void)doneExhibitDocument;

@end

@implementation ExhibitDetailInfoFunctionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDetailInfo:(ExhibitDetailInfoBean *)detailInfo parentView:(UIView *)parentView
{
    self = [super init];
    if (self) {
        // save exhibit detail info
        _exhibitDetailInfo = detailInfo;
        
        // check operation privilege and set operations
        _operations = [[NSMutableArray alloc] init];
        if (_exhibitDetailInfo.canCollect) {
            [_operations addObject:NSLocalizedString(@"exhibit detail info collect operation", nil)];
        }
        if (_exhibitDetailInfo.canDownload) {
            [_operations addObject:NSLocalizedString(@"exhibit detail info download operation", nil)];
        }
        if (_exhibitDetailInfo.canShare) {
            [_operations addObject:NSLocalizedString(@"exhibit detail info share operation", nil)];
        }
        if (_exhibitDetailInfo.canExhibit) {
            [_operations addObject:NSLocalizedString(@"exhibit detail info exhibit operation", nil)];
        }
        
        // increase number of section for operation section
        if (nil != _operations && 0 < [_operations count]) {
            _numberOfSections++;
        }
        
        // init core location manager
        _coreLocationManager = [[CLLocationManager alloc] init];
        
        // set delegate
        _coreLocationManager.delegate = self;
        
        // set accuracy
        _coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // set distance update filter
        _coreLocationManager.distanceFilter = CLDISTANCEUPDATEFILTER;
        
        // start updating location
        [_coreLocationManager startUpdatingLocation];
        
        // set frame
        [self setFrame:CGRectMake(parentView.bounds.size.width - WIDTH, -NAVIGATIONBAR_HEIGHT, WIDTH, parentView.bounds.size.height + NAVIGATIONBAR_HEIGHT)];
        
        // init top banner label view
        UILabel *_topBannerLabelView = [[UILabel alloc] init];
        
        // set frame
        [_topBannerLabelView setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, NAVIGATIONBAR_HEIGHT)];
        
        // set attributes
        _topBannerLabelView.text = NSLocalizedString(@"exhibit detail info operation view top banner label view text", nil);
        _topBannerLabelView.textColor = [UIColor whiteColor];
        _topBannerLabelView.shadowColor = [UIColor darkGrayColor];
        _topBannerLabelView.textAlignment = UITextAlignmentCenter;
        _topBannerLabelView.font = [UIFont boldSystemFontOfSize:20.0];
        
        // set background color
        _topBannerLabelView.backgroundColor = [UIColor orangeColor];
        
        // init function operation table view
        _functionOperationTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + NAVIGATIONBAR_HEIGHT, self.bounds.size.width, self.bounds.size.height - NAVIGATIONBAR_HEIGHT) style:UITableViewStyleGrouped];
        
        // set background view and its color
        _functionOperationTableView.backgroundView = [[UIView alloc] init];
        _functionOperationTableView.backgroundView.backgroundColor = [UIColor lightGrayColor];
        
        // set data source and delegate
        _functionOperationTableView.dataSource = self;
        _functionOperationTableView.delegate = self;
        
        // add top banner label view and function operation table view as subviews of exhibit detail info function view
        [self addSubview:_topBannerLabelView];
        [self addSubview:_functionOperationTableView];
        
        // add exhibit detail info function view as subview of parent view and send to back
        [parentView addSubview:self];
        [parentView sendSubviewToBack:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGFloat)width{
    // return exhibit detail info function view width
    return WIDTH;
}

- (void)forceCancelExhibit
{
    // manual select cancel exhibit row in operation section
    [self tableView:_functionOperationTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[_operations indexOfObject:NSLocalizedString(@"exhibit detail info cancel exhibit operation", nil)] inSection:0]];
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
    return 0 == section ? [_operations count] : ROWSINEXHIBITURLSECTION;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Return the title of header in the section.
    return 0 == section ? NSLocalizedString(@"exhibit detail info operation view operation section title", nil) : NSLocalizedString(@"exhibit detail info operation view exhibit section title", nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = 0 == indexPath.section ? @"Exhibit operation cell" : @"Exhibit url cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            // set accessory type
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            // set operation name as text label text
            cell.textLabel.text = [_operations objectAtIndex:indexPath.row];
            
            break;
            
        case 1:
            // set selection type
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            // set background view and its content mode
            cell.backgroundView = [[UIImageView alloc] initWithImage:_exhibitQRImage];
            cell.backgroundView.contentMode = UIViewContentModeScaleAspectFit;
            
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
    return 0 == indexPath.section ? tableView.rowHeight : EXHIBITQRIMAGE_HEIGHT;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *_ret = indexPath;
    
    // exhibit url couldn't be selected
    if (0 != indexPath.section) {
        _ret = nil;
    }
    
    return _ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // check the selected indexPath
    if (0 == indexPath.section) {
        // get selected operation
        NSString *_operation = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        
        // define post request param dictionary
        NSMutableDictionary *_paramDic = [[NSMutableDictionary alloc] init];
        
        // check selected operation
        if ([NSLocalizedString(@"exhibit detail info collect operation", nil) isEqualToString:_operation]) {
            // collect document
            // set param key and value
            [_paramDic setObject:NSRBGServerFieldString(@"collect document post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
            [_paramDic setObject:_exhibitDetailInfo.id forKey:NSRBGServerFieldString(@"post http request param key document id", nil)];
            [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
            [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
        }
        else if ([NSLocalizedString(@"exhibit detail info exhibit operation", nil) isEqualToString:_operation]) {
            // exhibit document
            // set param key and value
            [_paramDic setObject:NSRBGServerFieldString(@"exhibit document post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
            [_paramDic setObject:[NSNumber numberWithDouble:_location2DCoordinate.latitude] forKey:NSRBGServerFieldString(@"exhibit document post http request param key exhibit location x", nil)];
            [_paramDic setObject:[NSNumber numberWithDouble:_location2DCoordinate.longitude] forKey:NSRBGServerFieldString(@"exhibit document post http request param key exhibit location y", nil)];
            [_paramDic setObject:_exhibitDetailInfo.id forKey:NSRBGServerFieldString(@"post http request param key document id", nil)];
            [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key user id", nil)];
            [_paramDic setObject:[NSNumber numberWithInt:1] forKey:NSRBGServerFieldString(@"post http request param key company id", nil)];
        }
        else if ([NSLocalizedString(@"exhibit detail info cancel exhibit operation", nil) isEqualToString:_operation]) {
            // cancel exhibit document
            // set param key and value
            [_paramDic setObject:NSRBGServerFieldString(@"cancel exhibit document post http request", nil) forKey:NSRBGServerFieldString(@"post http request param key action", nil)];
            [_paramDic setObject:_exhibitSessionId forKey:NSRBGServerFieldString(@"cancel exhibit document post http request param key session id", nil)];
        }
        else {
            NSLog(@"Operation = %@ not implement now", _operation);
        }
        
        // send asynchronous post http request
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
                            {
                                // get and check status
                                NSString *_status = [[data objectFromJSONData] objectForKey:NSRBGServerFieldString(@"collect, exhibit and cancel exhibit document request response data key status", nil)];
                                if (nil != _status && [NSRBGServerFieldString(@"collect, exhibit and cancel exhibit document request response status ok", nil) isEqualToString:_status]) {
                                    // check selected operation
                                    if ([NSLocalizedString(@"exhibit detail info collect operation", nil) isEqualToString:_operation]) {
                                        // collect document
                                        // remove collect operation cell item with animation
                                        [_operations removeObject:_operation];
                                        [self performSelectorOnMainThread:@selector(removeOperationCellItem:) withObject:indexPath waitUntilDone:NO];
                                    }
                                    else if ([NSLocalizedString(@"exhibit detail info exhibit operation", nil) isEqualToString:_operation]) {
                                        // exhibit document
                                        // get session id and saved
                                        _exhibitSessionId = [[data objectFromJSONData] objectForKey:NSRBGServerFieldString(@"exhibit document request response data key session id", nil)];
                                        
                                        // reload exhibit operation cell item with animation
                                        [_operations replaceObjectAtIndex:[_operations indexOfObject:_operation] withObject:NSLocalizedString(@"exhibit detail info cancel exhibit operation", nil)];
                                        [tableView performSelectorOnMainThread:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:[NSArray arrayWithObject:indexPath] waitUntilDone:YES];
                                        
                                        // increase number of section for exhibit url section
                                        _numberOfSections++;
                                        
                                        // done exhibit document
                                        [self performSelectorOnMainThread:@selector(doneExhibitDocument) withObject:nil waitUntilDone:NO];
                                    }
                                    else if ([NSLocalizedString(@"exhibit detail info cancel exhibit operation", nil) isEqualToString:_operation]) {
                                        // cancel exhibit document
                                        // clear exhibit session id
                                        _exhibitSessionId = nil;
                                        
                                        // reload exhibit operation cell item with animation
                                        [_operations replaceObjectAtIndex:[_operations indexOfObject:_operation] withObject:NSLocalizedString(@"exhibit detail info exhibit operation", nil)];
                                        [tableView performSelectorOnMainThread:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:[NSArray arrayWithObject:indexPath] waitUntilDone:YES];
                                        
                                        // decrease number of section for exhibit url section
                                        _numberOfSections--;
                                        
                                        // reload data
                                        [tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                    }
                                }
                                else {
                                    // operation failed
                                    //
                                }
                            }
                            
                            break;
                            
                        default:
                            NSLog(@"Post asynchronous http request failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                            
                            // failed
                            //
                            
                            break;
                    }
                }
                else {
                    // not a http response
                    NSLog(@"Send asynchronous post http request response not a http response");
                }
            }
            else {
                NSLog(@"Send asynchronous post http request error, code = %d and message = %@", error.code, error.domain);
                
                // error
                //
            }
        }];
    }
    else {
        NSLog(@"Not operation section be selected");
    }
}

#pragma mark - core location manager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // save new location coordinate
    _location2DCoordinate = newLocation.coordinate;
}

#pragma mark - Inner extension

- (void)removeOperationCellItem:(NSIndexPath *)indexPath
{
    // begin update
    [_functionOperationTableView beginUpdates];
    
    // delete with animation
    [_functionOperationTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    // end update
    [_functionOperationTableView endUpdates];
}

- (void)doneExhibitDocument
{
    // reload function operation table view data
    [_functionOperationTableView reloadData];
    
    // get exhibit document quick response code file
    // define the request
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@_%@.png", [NSString stringWithFormat:NSUrlString(@"quick response code image file url format", nil), NSUrlString(@"remote background server root url", nil)], _exhibitDetailInfo.id, _exhibitSessionId]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
    // set request method
    _request.HTTPMethod = @"GET";
    
    // send the request
    [NSURLConnection sendAsynchronousRequest:_request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // check the error
        if (nil == error) {
            // check the response
            if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
                // get http response
                NSHTTPURLResponse *_httpResponse = (NSHTTPURLResponse *)response;
                
                // get and check http response status code
                switch (_httpResponse.statusCode) {
                    case 200:
                        // save exhibit quick response code image and reload row in exhibit url section
                        _exhibitQRImage = [UIImage imageWithData:data];
                        
                        [_functionOperationTableView performSelectorOnMainThread:@selector(reloadRowsAtIndexPaths:withRowAnimation:) withObject:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] waitUntilDone:NO];
                        
                        break;
                        
                    default:
                        NSLog(@"Get exhibit document quick response code file failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        //
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send get exhibit document quick response code file request response not a http response");
            }
        }
        else {
            NSLog(@"Send get exhibit document quick response code file http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
}

@end
