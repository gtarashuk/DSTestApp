//
//  UITableView+BottomRefreshControl.h
//  DS Test App
//
//  Created by Grigory Tarashuk on 3/23/17.
//  Copyright © 2017 Test Name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (BottomRefreshControl)

@property (nullable, nonatomic) UIRefreshControl *bottomRefreshControl;

@end


@interface UIRefreshControl (BottomRefreshControl)

@property (nonatomic) CGFloat triggerVerticalOffset;

@end
