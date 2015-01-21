//
//  WritePostVC.h
//  WomenHealthApp
//
//  Created by 朱青 on 15/1/10.
//  Copyright (c) 2015年 WomenHealthApp. All rights reserved.
//

#import "BasicVC.h"
#import "UIPlaceHolderTextView.h"

@interface CustomButton : UIButton

@property(nonatomic,assign)BOOL isLoadImage;//不可修改

@end

@interface WritePostVC : BasicVC

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *postTextView;
@property (weak, nonatomic) IBOutlet UIView *postView;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UITextField *postTextFiled;

@property (strong, nonatomic) NSMutableArray  *imageDataArray; //图片二级制数据
@property (strong, nonatomic) NSMutableArray  *imageTextArray; //接口返回图片标签数组
@property (strong, nonatomic) NSMutableArray  *imageIdArray;   //发表时上传json数组
@property (strong, nonatomic) NSMutableArray  *imageArray;     //图片数组

@property (strong, nonatomic) NSString *currentFid;

@end
