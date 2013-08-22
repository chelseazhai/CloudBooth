//
//  ContentTableViewController.m
//  CloudBooth
//
//  Created by Ares on 13-8-9.
//  Copyright (c) 2013年 watermelontech. All rights reserved.
//

#import "ContentTableViewController.h"

// http request utils
#import "HttpReqUtils.h"

// content table view cell
#import "ContentTableViewCell.h"

// content table view data source bean
#import "ContentTableViewDataSourceBean.h"

// exhibit detail info view controller
#import "ExhibitDetailInfoViewController.h"

@interface ContentTableViewController ()

// content table view data source
@property (nonatomic, retain) NSMutableArray *dataSource;

// content table view controller's tab bar item image
@property (nonatomic, readonly) UIImage *contentTabBarItemImage;

// done get content table view data source
- (void)doneGetContentTableViewDataSource;

// get visible cells thumbnails from remote background server if needed
- (void)getVisibleCellsThumbnails;

// revise the get thumbnail asynchronous get http request url
- (NSURL *)reviseGetThumbnailReqUrl:(NSString *)origUrlString;

// send get thumbnail asynchronous get http request
- (void)sendGetThumbnailAsyncGetHttpRequest:(NSString *)thumbnailUrl;

@end

@implementation ContentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // re-init tab content tab bar item
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"tab" image:self.contentTabBarItemImage tag:-1];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // get content table view data source
    // send get content table view data source asynchronous post http request
    [NSURLConnection sendAsynchronousRequest:[HttpReqUtils genAsyncPostHttpRequest:self.contentTableDataSourceRequestUrl postParam:self.contentTableDataSourceRequestParam] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        // check the error
        if (nil == error) {
            // check the response
            if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
                // get http response
                NSHTTPURLResponse *_httpResponse = (NSHTTPURLResponse *)response;
                
                // get and check http response status code
                switch (_httpResponse.statusCode) {
                    case 200:
                        // reload data source
                        if (nil == _dataSource) {
                            _dataSource = [[NSMutableArray alloc] init];
                        }
                        else if (0 != _dataSource.count) {
                            [_dataSource removeAllObjects];
                        }
                        [_dataSource addObjectsFromArray:[data objectFromJSONData]];
                        
                        // done get content table view data source
                        [self performSelectorOnMainThread:@selector(doneGetContentTableViewDataSource) withObject:nil waitUntilDone:NO];
                        
                        break;
                        
                    default:
                        NSLog(@"Get content table view data source failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        //
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send get content table view data source request response not a http response");
            }
        }
        else {
            NSLog(@"Send get content table view data source http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Content table view cell";
    
    ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // get the cell's data source bean
    ContentTableViewDataSourceBean *_cellDataSourceBean = [ContentTableViewDataSourceBean objectFromJSONData:[_dataSource objectAtIndex:indexPath.row] thumbnails:gImgUrlImageDictionary];
    
    // Configure the cell...
    cell.cellImageView.image = _cellDataSourceBean.thumbnail;
    cell.cellTitleLabel.text = _cellDataSourceBean.title;
    cell.cellContentLabel.text = _cellDataSourceBean.content;
    cell.cellNumberOfBeenReadLabel.text = [NSString stringWithFormat:@"%d", _cellDataSourceBean.numberOfBeenRead];
    
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

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // get content table view visible cells data thumbnail
    [self getVisibleCellsThumbnails];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // get content table view visible cells data thumbnail
    [self getVisibleCellsThumbnails];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // content table view cell height
    return [ContentTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // define exhibit detail info view controller
    ExhibitDetailInfoViewController *_exhibitDetailInfoViewController = [[ExhibitDetailInfoViewController alloc] init];
    
    // pass the selected exhibit id to the view controller
    _exhibitDetailInfoViewController.exhibitDocId = [[_dataSource objectAtIndex:indexPath.row] objectForKey:NSRBGServerFieldString(@"get document, favorite and recent shared list request response data key id", nil)];
    
    // navigation to exhibit detail info view controller
    [self.navigationController pushViewController:_exhibitDetailInfoViewController animated:YES];
}

#pragma mark - Content table data source request protocol

- (NSURL *)contentTableDataSourceRequestUrl
{
    // return remote background server root url
    return [NSURL URLWithString:[NSString stringWithFormat:NSUrlString(@"data servlet url format", nil), NSUrlString(@"remote background server root url", nil)]];
}

#pragma mark - Inner extension

- (UIImage *)contentTabBarItemImage
{
    // define image draw rectangle
    CGRect _drawRect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // begin graphics
    UIGraphicsBeginImageContext(_drawRect.size);
    
    // get current graphics content
    CGContextRef _currentGraphicsContext = UIGraphicsGetCurrentContext();
    
    // set draw color and draw
    CGContextSetFillColorWithColor(_currentGraphicsContext, [[UIColor blackColor] CGColor]);
    CGContextFillRect(_currentGraphicsContext, _drawRect);
    
    // get the draw image from current image context
    UIImage *_retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // end graphics
    UIGraphicsEndImageContext();
    
    return _retImage;
}

- (void)doneGetContentTableViewDataSource
{
    // reload table view data source
    [self.tableView reloadData];
    
    // get content table view visible cells data thumbnail
    [self getVisibleCellsThumbnails];
}

- (void)getVisibleCellsThumbnails
{
    // get content table view visible cells data thumbnail
    for (ContentTableViewCell *visibleCell in self.tableView.visibleCells) {
        // get visiable cell's data
        NSDictionary *_cellData = [_dataSource objectAtIndex:[self.tableView indexPathForCell:visibleCell].row];
        
        // check visiable cell's data
        if (nil != _cellData) {
            // get thumbnail url
            NSString *_thumbnailUrl = [_cellData objectForKey:NSRBGServerFieldString(@"get document, favorite, recent shared list and document detail info request response data key thumbnail url", nil)];
            
            // get and check the thumbnail
            if (nil == [gImgUrlImageDictionary objectForKey:_thumbnailUrl]) {
                // save the thumbnail temp using content table view cell
                [gImgUrlImageDictionary setObject:visibleCell forKey:_thumbnailUrl];
                
                // get thumbnail from server
                [self sendGetThumbnailAsyncGetHttpRequest:_thumbnailUrl];
            }
        }
    }
}

- (NSURL *)reviseGetThumbnailReqUrl:(NSString *)origUrlString
{    
    // revise original url string and generate the revised url
    return [NSURL URLWithString:[[origUrlString stringByReplacingOccurrencesOfString:@"\\" withString:@"/"] stringByReplacingOccurrencesOfString:@"//" withString:@"/"]];
}

- (void)sendGetThumbnailAsyncGetHttpRequest:(NSString *)thumbnailUrl
{
    // get content table cell
    ContentTableViewCell *_cell = (ContentTableViewCell *)[gImgUrlImageDictionary objectForKey:thumbnailUrl];
    
    // define the request
    NSMutableURLRequest *_request = [[NSMutableURLRequest alloc] initWithURL:[self reviseGetThumbnailReqUrl:[NSString stringWithFormat:@"%@%@", NSUrlString(@"remote background server root url", nil), thumbnailUrl]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
    
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
                        // save the thumbnail
                        [gImgUrlImageDictionary setObject:[UIImage imageWithData:data] forKey:thumbnailUrl];
                        
                        // update content table cell image
                        [_cell.cellImageView performSelectorOnMainThread:@selector(setImage:) withObject:[gImgUrlImageDictionary objectForKey:thumbnailUrl] waitUntilDone:NO];
                        
                        break;
                        
                    default:
                        NSLog(@"Get thumbnail failed, response message = %@", [NSHTTPURLResponse localizedStringForStatusCode:_httpResponse.statusCode]);
                        
                        // failed
                        // remove object for thumbnail url
                        [gImgUrlImageDictionary removeObjectForKey:thumbnailUrl];
                        
                        break;
                }
            }
            else {
                // not a http response
                NSLog(@"Send get thumbnail request response not a http response");
            }
        }
        else {
            NSLog(@"Send get thumbnail http request error, code = %d and message = %@", error.code, error.domain);
            
            // error
            //
        }
    }];
}

@end
