//
//  MenuViewController.h
//  Triathlon
//
//  Created by Aleksandr on 07/12/15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideNavigationMainController.h"

@interface MenuViewController : LeftViewController <UITableViewDataSource,UITableViewDelegate,LeftViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SlideNavigationMainController *mainViewController;
-(instancetype)init;
@end
