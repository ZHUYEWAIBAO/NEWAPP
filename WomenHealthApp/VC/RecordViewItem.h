//
//  RecordViewItem.h
//  WomenHealthApp
//
//  Created by Daniel on 14/11/19.
//  Copyright (c) 2014年 WomenHealthApp. All rights reserved.
//

#import <UIKit/UIKit.h>
 /// ss
@protocol RecordItemProtocal <NSObject>

-(void)didSelDismss;

-(void)comfirmSelect;

@end

@interface RecordViewItem : UIView{
//    NSMutableArray *ZZAry;
}

@property (weak, nonatomic) IBOutlet UILabel *titleNameLab;

@property (weak, nonatomic) IBOutlet UILabel *tishiLab;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property(nonatomic,strong) NSMutableArray *ZZAry;


@property (weak, nonatomic) IBOutlet UIScrollView *alterScrollview;


- (IBAction)cancel:(id)sender;

- (IBAction)confirm:(id)sender;



- (IBAction)click:(id)sender;

@property (nonatomic ,strong) id<RecordItemProtocal >delegete;

@end



