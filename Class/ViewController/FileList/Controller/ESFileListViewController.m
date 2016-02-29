//
//  ESFileListViewController.m
//  file
//
//  Created by 翟泉 on 16/2/27.
//  Copyright © 2016年 云之彼端. All rights reserved.
//

#import "ESFileListViewController.h"
#import "ESFileManager.h"
#import "ESFileListTableViewCell.h"

#import "KxMovieViewController.h"

@interface ESFileListViewController ()
<UITableViewDataSource, UITableViewDelegate>

{
    NSString *_directoryPath;
    NSArray<ESFileModel *> *dataSource;
    
//    int *selectedItems;
    
    NSMutableArray<NSNumber *> *_selectedItems;
}


@property (strong, nonatomic) UITableView *tableView;

/**
 *  编辑
 */
@property (assign, nonatomic) BOOL editing;

@end

@implementation ESFileListViewController

- (instancetype)init; {
    if (self = [super init]) {
        _directoryPath = @"";
        self.title = @"文件列表";
    }
    return self;
}

- (instancetype)initWithDirectoryPath:(NSString *)directoryPath; {
    if (self = [super init]) {
        _directoryPath = directoryPath;
        self.title = [directoryPath lastPathComponent];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self reloadFileList];
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(editNavigationItem)];
    self.navigationItem.rightBarButtonItems = @[editButtonItem];
}

/**
 *  加载文件列表
 */
- (void)reloadFileList; {
    dataSource = [[ESFileManager sharedInstance] contentsOfDirectoryPath:_directoryPath];
    [_tableView reloadData];
}

#pragma mark - 导航栏
- (void)normalNavigationItem; {
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStyleDone target:self action:@selector(editNavigationItem)];
    self.navigationItem.leftBarButtonItems = @[];
    self.navigationItem.rightBarButtonItems = @[editButtonItem];
    
    self.tabBarController.tabBar.hidden = NO;
    
    self.tableView.height = SSize.height-64-44;
    
    self.editing = NO;
}

- (void)editNavigationItem; {
    UIBarButtonItem *normalButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(normalNavigationItem)];
    UIBarButtonItem *deleteButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteItem)];
    deleteButtonItem.tintColor = ColorRGB(217, 92, 92);
    UIBarButtonItem *selectAllButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全选" style:UIBarButtonItemStylePlain target:self action:@selector(selectAllItem)];
    self.navigationItem.leftBarButtonItems = @[selectAllButtonItem];
    self.navigationItem.rightBarButtonItems = @[normalButtonItem, deleteButtonItem];
    
    self.tabBarController.tabBar.hidden = YES;
    
    self.tableView.height = SSize.height-64;
    
    self.editing = YES;
}

/**
 *  进入/取消编辑状态
 *
 *  @param editing <#editing description#>
 */
- (void)setEditing:(BOOL)editing; {
    _editing = editing;
    if (editing) {
        _selectedItems = [NSMutableArray arrayWithCapacity:dataSource.count];
        for (NSInteger i=0; i<dataSource.count; i++) {
            _selectedItems[i] = @(NO);
        }
    }
    else {
        _selectedItems = nil;
    }
    [self.tableView reloadData];
    [self updateTitle];
}

/**
 *  全选/取消全选
 */
- (void)selectAllItem; {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == 0"];
    NSArray *selectedItems = [_selectedItems filteredArrayUsingPredicate:predicate];
    if ([selectedItems count] == 0) {
        // 已经全选
        _selectedItems = [NSMutableArray arrayWithCapacity:dataSource.count];
        for (NSInteger i=0; i<dataSource.count; i++) {
            _selectedItems[i] = @(NO);
        }
    }
    else {
        // 未全选
        __weak typeof(_selectedItems) weakArray = _selectedItems;
        [_selectedItems enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj boolValue]) {
                [weakArray replaceObjectAtIndex:idx withObject:@YES];
            }
        }];
    }
    [self.tableView reloadData];
    
    [self updateTitle];
}

/**
 *  删除选中文件
 */
- (void)deleteItem; {
    [UIAlertView showAlertWithMessage:@"是否确定删除文件?" confirmBlock:^{
        __weak typeof(dataSource) weakDataSource = dataSource;
        [_selectedItems enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj boolValue]) {
                [[ESFileManager sharedInstance] removeFile:weakDataSource[idx]];
            }
        }];
        [self reloadFileList];
        self.editing = NO;
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return [dataSource count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return [tableView dequeueReusableCellWithIdentifier:@"File"];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(ESFileListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath; {
    [cell setMode:dataSource[indexPath.row]];
    [cell setEditing:self.editing animated:NO];
    
    if ([_selectedItems[indexPath.row] boolValue]) {
        [cell.selectButton setImage:[UIImage imageNamed:@"icon-checkbox-y"] forState:UIControlStateNormal];
    }
    else {
        [cell.selectButton setImage:[UIImage imageNamed:@"icon-checkbox-n"] forState:UIControlStateNormal];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section; {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    return 0;
}

#pragma mark - Edit

//- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath; {
//    NSLog(@"%s", __FUNCTION__);
//}
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath; {
//    NSLog(@"%s", __FUNCTION__);
//}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath; {
//    NSLog(@"%s", __FUNCTION__);
//    if (indexPath.row % 3 == 0) {
//        return NO;
//    }
//    return YES;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath; {
//    NSLog(@"%s", __FUNCTION__);
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_editing) {
        ESFileListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([_selectedItems[indexPath.row] boolValue]) {
            [_selectedItems replaceObjectAtIndex:indexPath.row withObject:@(NO)];
            [cell.selectButton setImage:[UIImage imageNamed:@"icon-checkbox-n"] forState:UIControlStateNormal];
        }
        else {
            [_selectedItems replaceObjectAtIndex:indexPath.row withObject:@(YES)];
            [cell.selectButton setImage:[UIImage imageNamed:@"icon-checkbox-y"] forState:UIControlStateNormal];
        }
        [self updateTitle];
        return;
    }
    
    ESFileModel *file = dataSource[indexPath.row];
    if (dataSource[indexPath.row].type == ESFileTypeDirectory) {
        [self.navigationController pushViewController:[[ESFileListViewController alloc] initWithDirectoryPath:[_directoryPath stringByAppendingFormat:@"/%@", file.name]] animated:YES];
    }
    else if (file.type == ESFileTypeVideo) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        if ([file.path.pathExtension isEqualToString:@"wmv"]) {
            [dict setObject:@5.0 forKey:KxMovieParameterMinBufferedDuration];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [dict setObject:@YES forKey:KxMovieParameterDisableDeinterlacing];
        }
        [self presentViewController:[KxMovieViewController movieViewControllerWithContentPath:file.path parameters:dict] animated:YES completion:NULL];
    }
    else if (file.type == ESFileTypeAudio) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        if ([file.path.pathExtension isEqualToString:@"wmv"]) {
            [dict setObject:@5.0 forKey:KxMovieParameterMinBufferedDuration];
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [dict setObject:@YES forKey:KxMovieParameterDisableDeinterlacing];
        }
        [self presentViewController:[KxMovieViewController movieViewControllerWithContentPath:file.path parameters:dict] animated:YES completion:NULL];
    }
}

#pragma mark - Private
/**
 *  更新控制器标题、导航栏标题/状态
 */
- (void)updateTitle; {

    if (_editing) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == 1"];
        NSArray *selectedItems = [_selectedItems filteredArrayUsingPredicate:predicate];
        if ([selectedItems count] == 0) {
            self.title = @"选择文件";
            self.navigationItem.rightBarButtonItems[1].enabled = NO;
        }
        else {
            self.title = [NSString stringWithFormat:@"已选择%ld个文件", [selectedItems count]];
            self.navigationItem.rightBarButtonItems[1].enabled = YES;
        }
        
        if ([selectedItems count] == [_selectedItems count]) {
            // 全选
            [self.navigationItem.leftBarButtonItems[0] setTitle:@"全不选"];
        }
        else {
            // 未全选
            [self.navigationItem.leftBarButtonItems[0] setTitle:@"全选"];
        }
    }
    else if ([_directoryPath length] == 0) {
        self.title = @"文件列表";
    }
    else {
        self.title = [_directoryPath lastPathComponent];
    }
}

#pragma mark - Lazy
- (UITableView *)tableView; {
    if (_tableView == NULL) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SSize.width, SSize.height-64-44) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [_tableView registerClass:[ESFileListTableViewCell class] forCellReuseIdentifier:@"File"];
    }
    return _tableView;
}

@end
