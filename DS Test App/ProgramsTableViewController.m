//
//  ProgramsTableViewController.m
//  DS Test App
//
//  Created by Grigory Tarashuk on 3/23/17.
//  Copyright © 2017 Test Name. All rights reserved.
//

#import "ProgramsTableViewController.h"
#import "OllTvDemo.h"
#import "ProgramTableViewCell.h"
#import "UIScrollView+BottomRefreshControl.h"

static NSString * const ProgramTableViewCellIdentifier = @"ProgramTableViewCell";
static NSString * const More = @"1";
static NSString * const Less = @"-1";


@interface ProgramsTableViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *resultDictionary;
@property BOOL hasMore;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) OllTvDemo *demoManager;

@end

@implementation ProgramsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.hasMore = YES;
    [self firstLoadOfPrograms];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)addRefreshControl{
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.triggerVerticalOffset = 100.;
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.bottomRefreshControl = self.refreshControl;
}

-(void)firstLoadOfPrograms{
    _demoManager = [[OllTvDemo alloc]init];
    [_demoManager getTVProgramsFromBorderId:@"0" andDirection:@"0" block:^(id resultObj) {
        if (resultObj !=nil){
            self.resultDictionary = resultObj;
            NSArray *tempArray = (NSArray *)[self.resultDictionary objectForKey:@"items"];
            self.items =tempArray.mutableCopy;
            NSLog(@"%@", _resultDictionary);
            NSNumber *more = [self.resultDictionary objectForKey:@"hasMore"];
            
            if (more.longValue > 0){
                self.hasMore = YES;
            }else{
                self.hasMore = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self addRefreshControl];

            });
        }
        
    }];
}

- (void)loadData{
    NSMutableDictionary *lastDictionary = self.items.lastObject;
    NSString *lastBorderId = [lastDictionary objectForKey:@"id"];
    [self.refreshControl beginRefreshing];
    [_demoManager getTVProgramsFromBorderId:lastBorderId andDirection:More block:^(id resultDic) {
        NSMutableDictionary *tempDic = (NSMutableDictionary *)resultDic;
        NSMutableArray *tempArray =(NSMutableArray *)[tempDic objectForKey:@"items"];
        NSNumber *more = [tempDic objectForKey:@"hasMore"];
        
        if (more.longValue > 0){
            self.hasMore = YES;
        }else{
            self.hasMore = NO;
        }
        for (int i=0; i<tempArray.count; i++){
            [self.items addObject:tempArray[i]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ((indexPath.row == self.items.count-5) && self.hasMore){
//        [self loadData];
//    }
    return [self programTableViewCellForIndexPath:indexPath];
}

- (ProgramTableViewCell *)programTableViewCellForIndexPath:(NSIndexPath *)indexpath{
    ProgramTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ProgramTableViewCellIdentifier forIndexPath:indexpath];
    
    [self configureProgramTableViewCell:cell atIndexPath:indexpath];
    
    return cell;
    
}

- (void)configureProgramTableViewCell:(ProgramTableViewCell *)cell atIndexPath:(NSIndexPath *)indexpath{
    
    NSMutableDictionary *dictionary = self.items[indexpath.row];
    
    NSString *icon = [dictionary objectForKey:@"icon"];
    NSURL *iconUrl = [NSURL URLWithString:icon];
    
    [self downloadImageWithURL:iconUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded){
           
            dispatch_async(dispatch_get_main_queue(), ^{

            cell.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
            cell.iconImageView.image = image;
            });
               
            
        }
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setTitleForCell:cell dictionary:dictionary];
}

- (void)setTitleForCell:(ProgramTableViewCell *)cell dictionary:(NSMutableDictionary *)dictionary{
    
    cell.nameLabel.text = (NSString *)[dictionary objectForKey:@"name"];
}



- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error){
            UIImage *image = [[UIImage alloc]initWithData:data];
            completionBlock(YES, image);
        }else{
            completionBlock(NO,nil);

        }
        
    }];
    [task resume];

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Lazy Init

-(NSMutableArray *)items{
    if (!_items){
        _items = [[NSMutableArray alloc]init];
    }
    return _items;
}

-(NSMutableDictionary *)resultDictionary{
    if (!_resultDictionary){
        _resultDictionary = [[NSMutableDictionary alloc]init];
    }
    return _resultDictionary;
}


@end
