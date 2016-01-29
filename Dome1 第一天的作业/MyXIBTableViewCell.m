//
//  MyXIBTableViewCell.m
//  Dome1 第一天的作业
//
//  Created by Qianfeng on 16/1/23.
//  Copyright © 2016年 ZZ. All rights reserved.
//

#import "MyXIBTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation MyXIBTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)configData:(MyModel *)model{
   
    self.uesrNameLabel.text = model.username;
    self.experienceLabel.text = model.experience;
    
    
    
    
/*********************** 请求图片的第一种方式 SDWebImage ********************************/
    
    NSString *path = [NSString stringWithFormat:@"http://10.0.8.8/sns%@",model.headimage];
    NSURL *url = [NSURL URLWithString:path];
    [self.headImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    
    
    /*  请求图片的第二种方式  同步 太卡
    NSString *path = [NSString stringWithFormat:@"http://10.0.8.8/sns%@",model.headimage];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    self.headImageView.image = [UIImage imageWithData:data];
    */
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
