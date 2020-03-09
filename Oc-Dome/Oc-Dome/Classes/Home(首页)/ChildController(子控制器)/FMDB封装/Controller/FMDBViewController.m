//
//  FMDBViewController.m
//  Oc-Dome
//
//  Created by 李含文 on 2019/4/13.
//  Copyright © 2019年 东莞市三心网络科技有限公司. All rights reserved.
//

#import "FMDBViewController.h"
#import "FMDBItem.h"


#define tableName @"text"
@interface FMDBViewController ()
<UITableViewDelegate,UITableViewDataSource>
/** <#注释#> */
@property(nonatomic, strong) NSMutableArray *itemArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** <#注释#> */
@property(nonatomic, strong) FMDatabase *db;
@end

@implementation FMDBViewController
- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNav];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"id"];
    [self loadData];
}
- (void)setNav {
    __weak typeof(self) weakSelf = self;
    UIButton *leftbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    leftbtn.hw_setTitle_normal(@"创建").hw_setFont(15).hw_setTitleColor_normal([UIColor blackColor]);
    leftbtn.actionBlock = ^{
        BOOL tag = [FMDBItem hw_createTableWithName:tableName db:self.db];
        if (tag) {
            NSLog(@"创建成功");
        } else {
            NSLog(@"创建失败");
        }
    };
    UIButton *deletebtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    deletebtn.actionBlock = ^{
        NSString *sql = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", tableName];
        BOOL tag = [self.db executeUpdate:sql];
        if (tag) {
            [weakSelf loadData];
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    };
    deletebtn.hw_setTitle_normal(@"删除表").hw_setFont(15).hw_setTitleColor_normal([UIColor blackColor]);
    UIButton *rightbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    rightbtn.hw_setTitle_normal(@"添加").hw_setFont(15).hw_setTitleColor_normal([UIColor blackColor]);
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:deletebtn],[[UIBarButtonItem alloc] initWithCustomView:rightbtn],[[UIBarButtonItem alloc] initWithCustomView:leftbtn]];
    rightbtn.actionBlock = ^{
        FMDBItem *item = [FMDBItem new];
        NSInteger num = arc4random() % 1000;
        item.name = [NSString stringWithFormat:@"李含文%ld",num];
        item.age = num;
        BOOL tag = [item hw_insertTableWithName:tableName db:self.db];
        if (tag) {
            NSLog(@"插入成功");
            [weakSelf loadData];
        } else {
            NSLog(@"插入失败");
        }
    };
    
}
- (void)loadData {
    NSArray *itemArray = [FMDBItem hw_queryTableWithName:tableName db:self.db];
    [self.itemArray removeAllObjects];
    [self.itemArray addObjectsFromArray:itemArray];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    FMDBItem *item = self.itemArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"ID:%ld 姓名:%@ 年龄:%ld ",item.ID, item.name, item.age];
    return cell;
}

- (FMDatabase *)db {
    if (!_db) {
        NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbPath = [docuPath stringByAppendingPathComponent:@"text.db"];
        NSLog(@"数据库路径:%@",dbPath);
        _db = [FMDatabase databaseWithPath:dbPath];
    }
    return _db;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDBItem *item = self.itemArray[indexPath.row];
    item.name = @"李含文";
    item.age = 18;
    BOOL tag = [item hw_updateTableWithName:tableName db:self.db];
    if (tag) {
        NSLog(@"操作成功");
        [self.tableView reloadData];
    } else {
        NSLog(@"操作失败");
    }
}

// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    FMDBItem *item = self.itemArray[indexPath.row];
    BOOL tag = [item hw_deleteTableWithName:@"text" db:self.db]; // 删除操作
    if (tag) {
        NSLog(@"删除成功");
        [self.itemArray removeObject:item];
        [self.tableView reloadData];
    } else {
        NSLog(@"删除失败");
    }
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
@end
