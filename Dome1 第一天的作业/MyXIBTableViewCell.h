//
//  MyXIBTableViewCell.h
//  Dome1 第一天的作业
//
//  Created by Qianfeng on 16/1/23.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyModel.h"
@interface MyXIBTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *uesrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
-(void)configData:(MyModel*)model;
@end
