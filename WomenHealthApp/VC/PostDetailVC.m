//
//  PostDetailVC.m
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/14.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "PostDetailVC.h"
#import "PostDetailCell.h"
#import "PostDetailModel.h"
#import "BbsCircleDetailVC.h"
#import "JSONKit.h"
#import "ImageScrollVC.h"
#import "WritePostVC.h"

@interface PostDetailVC ()<UIScrollViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    PostListModel *currentModel;
}

@property (strong, nonatomic) PostDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet CustomButton *photoBtn;

@property (strong, nonatomic) NSMutableArray  *imageDataArray; //图片二级制数据
@property (strong, nonatomic) NSMutableArray  *imageTextArray; //接口返回图片标签数组
@property (strong, nonatomic) NSMutableArray  *imageIdArray;   //发表时上传json数组
@property (strong, nonatomic) NSMutableArray  *imageArray;     //图片数组

@end

@implementation PostDetailVC

- (void)loadView
{
    [super loadView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteTheImage:) name:NOTIFICATION_IMAGE_DELETE object:nil];
    
    self.title = @"帖子详情";
    
    //允许下拉刷新
    self.tableView = self.postTableView;
    
    //允许上拉分页加载
    self.isNeedLoadMore=YES;
    self.page = 1;

}

- (void)viewDidLoad {
    [super viewDidLoad];

    _postListArray = [[NSMutableArray alloc]init];
    
//    self.inputTextField.inputAccessoryView = self.inputView;
    
    _imageDataArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageTextArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageIdArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self getThePostDetailWithTid:self.currentTid lastPage:NO];
    
}

- (void)getThePostDetailWithTid:(NSString *)tid lastPage:(BOOL)isLastPage
{
    if (self.page == 1) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    }
    
    NSString *path;
    if (isLastPage) {
        path = [NSString stringWithFormat:@"/api/dz/index.php?mod=viewthread&tid=%@&offset=%ld",self.currentTid,self.totalRowNum];
    }
    else{
        path = [NSString stringWithFormat:@"/api/dz/index.php?mod=viewthread&tid=%@&page=%ld",self.currentTid,self.page];
    }
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            NSDictionary *data = [dic objectForKey:@"data"];
            
            PostDetailModel *detailModel = [PostDetailModel parseDicToPostDetailObject:data];
            self.detailModel = detailModel;
            
            [self layOutTheHeadView];
            
            self.totalRowNum = [CHECK_VALUE([data objectForKey:@"total_subject"]) integerValue];
            self.totalPage = [CHECK_VALUE([data objectForKey:@"total_page"]) integerValue];
            
            NSArray *ary = CHECK_ARRAY_VALUE([data objectForKey:@"view_threadlist"]);
            
            if (ary.count>0) {
                //如果是第一页，清空数组
                if (self.page == 1 && !isLastPage) {
                    
                    [self.postListArray removeAllObjects];
                   
                }
                
                for (NSDictionary *dic in ary) {
                    PostListModel *model = [PostListModel parseDicToPostListObject:dic];
                    
                    [self.postListArray addObject:model];
                }
                
                if(self.page == 1&&[self.postListArray count]>0){
                    
                    //tableview返回第一行
                    self.postTableView.contentSize = CGSizeMake(SCREEN_SIZE.width, 0);
                    
                }

                //当前数据小于总数据的时候页数++
                if (self.page < self.totalPage) {
                    
                    self.footview.hidden=NO;
                }
                else{
                    self.footview.hidden=YES;
                }
    
            }
            [self.postTableView reloadData];
            
            [SVProgressHUD dismiss];

            
        }
        else{
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        [self doneLoadingTableViewData];
        [self.footview endRefreshing];
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        [self doneLoadingTableViewData];
        [self.footview endRefreshing];
    }];

    
}

- (void)layOutTheHeadView
{
    if ([@"1" isEqualToString:self.detailModel.digest]) {
        [self.jingImageView setHidden:NO];
    }
    self.nameLabel.text = self.detailModel.subject;
    self.circleLabel.text = self.detailModel.fid_name;
    
    [self.totalButton setTitle:self.detailModel.total_subject forState:UIControlStateNormal];
    
    CGRect rect1 =  self.nameLabel.frame;
    rect1.size.height = HeightForString(self.detailModel.subject, 14.0, 260) + 10;
    self.nameLabel.frame = rect1;
    
    CGRect rect2 =  self.topView.frame;
    rect2.size.height = rect1.size.height + 3;
    self.topView.frame = rect2;
    
    CGRect rect3 =  self.bottomView.frame;
    rect3.origin.y = rect2.size.height;
    self.bottomView.frame = rect3;
    
    CGRect rect5 =  self.lineImageView.frame;
    rect5.origin.y = rect3.size.height + rect3.origin.y;
    self.lineImageView.frame = rect5;
    
    CGRect rect4 =  self.headView.frame;
    rect4.size.height = rect5.size.height + rect5.origin.y;
    self.headView.frame = rect4;
    
    self.postTableView.tableHeaderView = self.headView;
}

- (IBAction)circleClickAction:(id)sender
{
    if (self.isFromMyCircle) {
        
        BbsCircleDetailVC *vc = [[BbsCircleDetailVC alloc]initWithNibName:@"BbsCircleDetailVC" bundle:nil];
        vc.currentFid = self.detailModel.fid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.postListArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:[PostDetailCell cellIdentifier]];
    if (cell ==nil) {
        cell = (PostDetailCell *)[[[NSBundle mainBundle] loadNibNamed:@"PostDetailCell" owner:self options:nil] objectAtIndex:0];
        
    }
    
    PostListModel *model = [self.postListArray objectAtIndex:indexPath.row];
    
    [cell.headImageView setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageWithContentFileName:@"Set_people_head_image.png"]];
    
    cell.authorLabel.text = model.author;
    cell.timeLabel.text = model.dateline;
    cell.postLabel.text = model.message;
    
    [cell.replyButton addTarget:self action:@selector(replyClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.replyButton setTag:1000 + indexPath.row];

    for (NSInteger i = 0; i < model.imgInfosArray.count; i++) {
        
        if (i < 3) {
            UIButton *button = [cell valueForKey:[NSString stringWithFormat:@"photoButton%ld",i ]];
            [button setImageWithURL:[model.imgInfosArray objectAtIndex:i] forState:UIControlStateNormal placeholderImage:[UIImage imageWithContentFileName:@"loading_default_bg.png"]];
            [button addTarget:self action:@selector(imageClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [button setTag:indexPath.row * 100 +i];
            [button setHidden:NO];
        }

    }
    
    CGRect rect1 = cell.authorLabel.frame;
    rect1.size.width = WidthForString(model.author, 14.0, 30);
    
    if (rect1.size.width >= 210) {
        rect1.size.width = 210;
    }
    cell.authorLabel.frame = rect1;
    
    if ([@"1" isEqualToString:model.louzhu]) {
        
        cell.louZhuLabel.text = @"楼主";
        
        [cell.louZhuImageView setHidden:NO];
        
        CGRect rect2 = cell.louZhuImageView.frame;
        rect2.origin.x = rect1.size.width + rect1.origin.x + 5;
        cell.louZhuImageView.frame = rect2;
    }
    else{
        cell.louZhuLabel.text = [NSString stringWithFormat:@"%@楼",model.position];
        
        //如果是用户自己发表的帖子，显示删除按钮
        if ([USERINFO.uid isEqualToString:model.authorid]) {
            [cell.deletePostButton setHidden:NO];
            [cell.deletePostImageV setHidden:NO];
            
            [cell.deletePostButton addTarget:self action:@selector(deleteThePostAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.deletePostButton setTag:2000+indexPath.row];
        }
        else{
            [cell.deletePostButton setHidden:YES];
            [cell.deletePostImageV setHidden:YES];
        }
    }
    
    CGRect rect3 = cell.postLabel.frame;
    rect3.size.height = HeightForString(model.message, 14.0, 250) + 10;
    cell.postLabel.frame = rect3;

    CGRect rect4 = cell.postView.frame;
    rect4.size.height = rect3.size.height + 5;
    cell.postView.frame = rect4;

    if (model.imgInfosArray.count > 0) {
        CGRect rect5 = cell.buttonView.frame;
        rect5.origin.y = rect4.size.height + rect4.origin.y;
        cell.buttonView.frame = rect5;
    
        if ([@"1" isEqualToString:model.position]) {
            
            [cell.replyView setHidden:YES];
            
            CGRect rect6 = cell.bigView.frame;
            rect6.size.height = rect5.size.height + rect5.origin.y;
            cell.bigView.frame = rect6;
        }
        else{
            
            if ([@"1" isEqualToString:model.replyModel.is_replay]) {
                
                [cell.replyContentView setHidden:NO];
                
                cell.replyNameLabel.text = model.replyModel.author;
                cell.replyTimeLabel.text = model.replyModel.sub_time;
                cell.replyContentLabel.text = model.replyModel.message;

                CGRect rect9 = cell.replyContentLabel.frame;
                rect9.size.height = HeightForString(model.replyModel.message, 12.0, 285) + 10;
                cell.replyContentLabel.frame = rect9;
                
                [cell.replyBgImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0) resizingMode:UIImageResizingModeStretch];
                
                CGRect rect8 = cell.replyContentView.frame;
                rect8.origin.y = rect5.size.height + rect5.origin.y;
                rect8.size.height = rect9.origin.y + rect9.size.height;
                cell.replyContentView.frame = rect8;
                
                CGRect rect7 = cell.replyView.frame;
                rect7.origin.y = rect8.size.height + rect8.origin.y;
                cell.replyView.frame = rect7;
                
                CGRect rect6 = cell.bigView.frame;
                rect6.size.height = rect7.size.height + rect7.origin.y;
                cell.bigView.frame = rect6;
                
            }
            else{
                
                [cell.replyContentView setHidden:YES];
                
                CGRect rect7 = cell.replyView.frame;
                rect7.origin.y = rect5.size.height + rect5.origin.y;
                cell.replyView.frame = rect7;
                
                CGRect rect6 = cell.bigView.frame;
                rect6.size.height = rect7.size.height + rect7.origin.y;
                cell.bigView.frame = rect6;
            }
            
            [cell.replyView setHidden:NO];

        }
            
        

    }
    else{
        [cell.buttonView setHidden:YES];
        
        if ([@"1" isEqualToString:model.position]) {
            
            [cell.replyContentView setHidden:YES];
            [cell.replyView setHidden:YES];
            
            CGRect rect6 = cell.bigView.frame;
            rect6.size.height = rect4.size.height + rect4.origin.y;
            cell.bigView.frame = rect6;
        }
        else{
            
            if ([@"1" isEqualToString:model.replyModel.is_replay]) {
                
                [cell.replyContentView setHidden:NO];
                
                cell.replyNameLabel.text = model.replyModel.author;
                cell.replyTimeLabel.text = model.replyModel.sub_time;
                cell.replyContentLabel.text = model.replyModel.message;

                CGRect rect9 = cell.replyContentLabel.frame;
                rect9.size.height = HeightForString(model.replyModel.message, 12.0, 285) + 10;
                cell.replyContentLabel.frame = rect9;
                
                [cell.replyBgImageView.image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 0, 5, 0) resizingMode:UIImageResizingModeStretch];
                
                CGRect rect8 = cell.replyContentView.frame;
                rect8.origin.y = rect4.size.height + rect4.origin.y;
                rect8.size.height = rect9.size.height + rect9.origin.y;
                cell.replyContentView.frame = rect8;
                
                
                CGRect rect7 = cell.replyView.frame;
                rect7.origin.y = rect8.size.height + rect8.origin.y;
                cell.replyView.frame = rect7;
                
                CGRect rect6 = cell.bigView.frame;
                rect6.size.height = rect7.size.height + rect7.origin.y;
                cell.bigView.frame = rect6;
                
            }
            else{
                
                [cell.replyContentView setHidden:YES];
                
                CGRect rect7 = cell.replyView.frame;
                rect7.origin.y = rect4.size.height + rect4.origin.y;
                cell.replyView.frame = rect7;
                
                CGRect rect6 = cell.bigView.frame;
                rect6.size.height = rect7.size.height + rect7.origin.y;
                cell.bigView.frame = rect6;
            }

            [cell.replyView setHidden:NO];

        }
        
        
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostListModel *model = [self.postListArray objectAtIndex:indexPath.row];
    
    if (model.imgInfosArray.count == 0) {
        
        if ([@"1" isEqualToString:model.position]) {
            
            return HeightForString(model.message, 14.0, 285) + 60 + 5 + 10 + 10;
        }
        else{
            
            if ([@"1" isEqualToString:model.replyModel.is_replay]) {
                
                return HeightForString(model.message, 14.0, 285) + 60 + 5 + 10 + 10 + 35 + HeightForString(model.replyModel.message, 12.0, 285) + 10 + 20;
            }
            else{
                return HeightForString(model.message, 14.0, 285) + 60 + 5 + 10 + 10 + 35;
            }
            
        }
        
    }
    else{
        
        if ([@"1" isEqualToString:model.position]) {
            
            return HeightForString(model.message, 14.0, 285) + 95 + 60 + 5 + 10 + 10;
        }
        else{
            
            if ([@"1" isEqualToString:model.replyModel.is_replay]) {
                return HeightForString(model.message, 14.0, 285) + 95 + 60 + 5 + 10 + 10 + 35 + HeightForString(model.replyModel.message, 12.0, 285) + 10 + 20;
            }
            else{
                return HeightForString(model.message, 14.0, 285) + 95 + 60 + 5 + 10 + 10 + 35;
            }
           
        }
    }
    
}

- (void)imageClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    PostListModel *model = [self.postListArray objectAtIndex:button.tag/100];
    
    ImageScrollVC *vc = [[ImageScrollVC alloc]initWithNibName:@"ImageScrollVC" bundle:nil];
    vc.imagesArray = [NSMutableArray arrayWithArray:model.imgInfosArray];
    vc.selectIndex = button.tag%100;
    vc.isFromPostDetail = YES;
    [self.navigationController pushViewController:vc animated:YES];
    

}

- (void)replyClickAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    PostListModel *model = [self.postListArray objectAtIndex:button.tag-1000];
    currentModel = model;
    
    [self.inputTextField setText:[NSString stringWithFormat:@"%@:",model.author]];
    [self.inputTextField becomeFirstResponder];
}

- (IBAction)sendPostAction:(id)sender
{
    if ([@"" isEqualToString:self.inputTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入内容~"];
        return;
    }

    if (!USERINFO.isLogin) {
        [self presentLoginVCAction];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self.params removeAllObjects];
    
    if (_imageDataArray.count > 0) {
        NSString *path = [NSString stringWithFormat:@"/api/dz/misc.php?mod=swfupload&action=swfupload&operation=upload&fid=%@&uid=%@",self.detailModel.fid,USERINFO.uid];
        
        for (NSInteger i = 0;i < _imageDataArray.count;i++) {
            
            NSData *imageData = [_imageDataArray objectAtIndex:i];
            
            [NETWORK_ENGINE requestWithPath:path Params:self.params imageData:imageData keyString:@"Filedata" CompletionHandler:^(MKNetworkOperation *completedOperation) {
                
                NSDictionary *dic=[completedOperation responseDecodeToDic];
                
                NSDictionary *statusDic = [dic objectForKey:@"status"];
                
                if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
                    
                    NSString *aidStr = [[dic objectForKey:@"data"] objectForKey:@"aid_str"];
                    [_imageTextArray addObject:aidStr];
                    
                    NSString *aid = [[dic objectForKey:@"data"] objectForKey:@"aid"];
                    [_imageIdArray addObject:aid];
                    
                    if (i == _imageDataArray.count - 1) {
                        
                        if ([self.inputTextField.text hasPrefix:[NSString stringWithFormat:@"%@:",currentModel.author]]) {
                            [self sendTheFirstAction];
                        }
                        else{
                            [self continueToSendThePost];
                        }
                        
                        
                    }
                    
                }
                else{
                    
                    [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
                }
                
                
            } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
            }];
            
        }
        
    }
    else{
        if ([self.inputTextField.text hasPrefix:[NSString stringWithFormat:@"%@:",currentModel.author]]) {
            [self sendTheFirstAction];
        }
        else{
            [self continueToSendThePost];
        }
    }
    

}

//回复帖子
- (void)sendTheFirstAction
{
    [self.params removeAllObjects];
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=post&action=reply&fid=%@&tid=%@&repquote=%@&extra=&infloat=yes&handlekey=reply&inajax=1&uid=%@",self.detailModel.fid,currentModel.tid,currentModel.pid,USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [self sendTheTextAction:[dic objectForKey:@"data"]];
            
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

- (void)sendTheTextAction:(NSDictionary *)dictionary
{
    
    [self.params removeAllObjects];
    [self.params setObject:@"" forKey:@"subject"];
    
    NSString *str;
    if ([self.inputTextField.text hasPrefix:[NSString stringWithFormat:@"%@:",currentModel.author]]) {
        NSString *replaceString = [self.inputTextField.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@:",currentModel.author] withString:@""];
        str = replaceString;
    }
    else{
        str = self.inputTextField.text;
    }
    
    if (_imageTextArray.count > 0) {
        for (NSString *aid in _imageTextArray) {
            str = [str stringByAppendingString:aid];
        }
        [self.params setObject:[_imageIdArray JSONString] forKey:@"attachnew"];
    }
    
    [self.params setObject:CHECK_VALUE(str) forKey:@"message"];
    [self.params setObject:CHECK_VALUE([dictionary objectForKey:@"noticeauthor"]) forKey:@"noticeauthor"];
    [self.params setObject:CHECK_VALUE([dictionary objectForKey:@"noticeauthormsg"]) forKey:@"noticeauthormsg"];
    [self.params setObject:CHECK_VALUE([dictionary objectForKey:@"noticetrimstr"]) forKey:@"noticetrimstr"];
    [self.params setObject:CHECK_VALUE([dictionary objectForKey:@"noticeauthor"]) forKey:@"reppid"];
    [self.params setObject:CHECK_VALUE([dictionary objectForKey:@"noticeauthor"]) forKey:@"reppost"];
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=post&infloat=yes&action=reply&fid=%@&extra=&tid=%@&replysubmit=yes&inajax=1&uid=%@",self.detailModel.fid,currentModel.tid,USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
  
            if (self.page == self.totalPage) {
                
                [self getThePostDetailWithTid:self.currentTid lastPage:YES];
                
            }
            
            [self.inputTextField resignFirstResponder];
            [self.inputTextField setText:@""];
            
            [_photoBtn setBackgroundImage:[UIImage imageWithContentFileName:@"camer_btn"] forState:UIControlStateNormal];
            _photoBtn.isLoadImage = NO;
     
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];
    
}

//跟帖
- (void)continueToSendThePost
{
    [self.params removeAllObjects];
    [self.params setObject:@"" forKey:@"subject"];
    
    NSString *str = self.inputTextField.text;
    
    if (_imageTextArray.count > 0) {
        for (NSString *aid in _imageTextArray) {
            str = [str stringByAppendingString:aid];
        }
        [self.params setObject:[_imageIdArray JSONString] forKey:@"attachnew"];
    }
    
    [self.params setObject:CHECK_VALUE(str) forKey:@"message"];

    PostListModel *model = [self.postListArray objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=post&action=reply&fid=%@&tid=%@&replysubmit=yes&infloat=yes&handlekey=fastpost&inajax=1&uid=%@",self.detailModel.fid,model.tid,USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [SVProgressHUD showSuccessWithStatus:@"发表成功"];
   
            if (self.page == self.totalPage) {
                
                [self getThePostDetailWithTid:self.currentTid lastPage:YES];
                
            }
            [self.inputTextField resignFirstResponder];
            [self.inputTextField setText:@""];
            
            [_photoBtn setBackgroundImage:[UIImage imageWithContentFileName:@"camer_btn"] forState:UIControlStateNormal];
            _photoBtn.isLoadImage = NO;
     
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

- (void)deleteTheImage:(NSNotification *)notifi
{
    if (notifi.object) {
        NSNumber *number = (NSNumber *)notifi.object;
        
        NSInteger index = [number integerValue];
        
        [_imageDataArray removeObjectAtIndex:index];
        
        [_photoBtn setBackgroundImage:[UIImage imageWithContentFileName:@"camer_btn"] forState:UIControlStateNormal];
        _photoBtn.isLoadImage = NO;
    }
    
}

//删除跟帖或回复
- (void)deleteThePostAction:(id)sender
{
    UIButton *button = (UIButton *)sender;
    PostListModel *model = [self.postListArray objectAtIndex:button.tag - 2000];
    //删除回复
    [self.params removeAllObjects];
    [self.params setObject:CHECK_VALUE(model.fid) forKey:@"fid"];
    [self.params setObject:CHECK_VALUE(model.tid) forKey:@"tid"];
    
    NSArray *array = [NSArray arrayWithObject:model.pid];
    [self.params setObject:CHECK_VALUE([array JSONString]) forKey:@"topiclist"];
    
    NSString *path = [NSString stringWithFormat:@"/api/dz/index.php?mod=topicadmin&action=delpost&modsubmit=yes&infloat=yes&modclick=yes&inajax=1&duid=%@",USERINFO.uid];
    
    [NETWORK_ENGINE requestWithPath:path Params:self.params CompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *dic=[completedOperation responseDecodeToDic];
        
        NSDictionary *statusDic = [dic objectForKey:@"status"];
        
        if ([@"1" isEqualToString:CHECK_VALUE([statusDic objectForKey:@"statu"])]) {
            
            [self.postListArray removeObject:model];
            [self.postTableView reloadData];
            
            [SVProgressHUD showSuccessWithStatus:@"已删除"];
  
        }
        else{
            
            [SVProgressHUD showErrorWithStatus:CHECK_VALUE([statusDic objectForKey:@"msg"])];
        }
        
        
    } ErrorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器忙，请稍候再试"];
        
    }];

}

- (IBAction)photoBtnAction:(id)sender
{

    if (_photoBtn.isLoadImage) {
        
        ImageScrollVC *vc = [[ImageScrollVC alloc]initWithNibName:@"ImageScrollVC" bundle:nil];
        vc.imagesArray = _imageArray;
        vc.selectIndex = 0;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.delegate = self;
        [actionSheet addButtonWithTitle:NSLocalizedString(@"拍照", nil)];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"从相册中选取", nil)];
        actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", nil)];
        [actionSheet showInView:self.view];
    }
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        switch (buttonIndex)
        {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                
                
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                break;
                
            default:
                return;
                break;
        }
        
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *photoImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImageJPEGRepresentation(photoImg,0.5);
    
    [_imageDataArray addObject:data];
    
    [_imageArray addObject:photoImg];
    
    [_photoBtn setBackgroundImage:photoImg forState:UIControlStateNormal];
    _photoBtn.isLoadImage = YES;

}

#pragma mark - 分页加载
//上拉分页加载
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == self.footview){
        self.page++;
        [self getThePostDetailWithTid:self.currentTid lastPage:NO];
    }
}

#pragma mark - 下拉刷新
- (void)reloadTableViewDataSource
{
    if (self.isLoading) { return;}
    self.page = 1;
    [self getThePostDetailWithTid:self.currentTid lastPage:NO];
    [super reloadTableViewDataSource];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {

    NSDictionary *userInfo = [notification userInfo];

    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];

    CGRect keyboardRect = [aValue CGRectValue];
 
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];

    [UIView animateWithDuration:animationDuration animations:^{

        self.inputView.frame = CGRectMake(self.inputView.frame.origin.x, self.view.bounds.size.height - keyboardRect.size.height - self.inputView.frame.size.height, self.inputView.frame.size.width, self.inputView.frame.size.height);
        
    }];
    
    
}


- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    
    NSTimeInterval animationDuration;
    
    [animationDurationValue getValue:&animationDuration];

    [UIView animateWithDuration:animationDuration animations:^{
        
        self.inputView.frame = CGRectMake(self.inputView.frame.origin.x, self.view.frame.size.height - self.inputView.frame.size.height, self.inputView.frame.size.width, self.inputView.frame.size.height);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
