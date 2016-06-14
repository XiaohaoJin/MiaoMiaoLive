//
//  JJGameLevelTable.h
//  
//
//  Created by 金晓浩 on 16/5/26.
//
//

#import <UIKit/UIKit.h>

typedef void(^selectLevelBlock)(NSInteger index);

@interface JJGameLevelTable : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *leverArray;
@property (nonatomic, copy) selectLevelBlock block;
- (void)setBlock:(selectLevelBlock)block;


@end
