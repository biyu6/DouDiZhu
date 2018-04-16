//
//  BYTestTwoVC.m
//  doudizhu
//
//  Created by 胡忠诚 on 2018/4/16.
//  Copyright © 2018年 biyu6. All rights reserved.
//

#import "BYTestTwoVC.h"

@interface BYTestTwoVC ()
/**初始的扑克牌*/
@property (nonatomic, strong)NSArray *firstPokerArr;
/**展示第一个人的牌*/
@property (nonatomic, strong)UILabel *oneLab;
/**展示第一个人的牌*/
@property (nonatomic, strong)UILabel *twoLab;
/**展示第一个人的牌*/
@property (nonatomic, strong)UILabel *threeLab;
/**展示第一个人的牌*/
@property (nonatomic, weak)UILabel *botLab;

@end
@implementation BYTestTwoVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 80, 30)];
    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    //三个人和底牌的展示：
    UILabel *oneLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 300, 100)];
    oneLab.backgroundColor = [UIColor redColor];
    oneLab.numberOfLines = 0;
    [self.view addSubview:oneLab];
    
    UILabel *twoLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 300, 100)];
    twoLab.backgroundColor = [UIColor yellowColor];
    twoLab.numberOfLines = 0;
    [self.view addSubview:twoLab];
    
    UILabel *threeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 320, 300, 100)];
    threeLab.backgroundColor = [UIColor greenColor];
    threeLab.numberOfLines = 0;
    [self.view addSubview:threeLab];
    
    UILabel *botLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 430, 300, 50)];//底牌
    botLab.backgroundColor = [UIColor cyanColor];
    botLab.numberOfLines = 0;
    [self.view addSubview:botLab];
    
    _oneLab = oneLab;
    _twoLab = twoLab;
    _threeLab = threeLab;
    _botLab = botLab;
    
    UILabel *promptLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 500, 300, 150)];//说明
    promptLab.text = @"最后一位数字是花色：0王、1黑、2红、3梅、4方        前两位是牌面数字：大王-00、小王-01、2-02、A-03、K-04、Q-05、J-06、10-07、9-08、8-09、7-10、6-11、5-12、4-13、3-14";
    promptLab.numberOfLines = 0;
    promptLab.backgroundColor = [UIColor grayColor];
    [self.view addSubview:promptLab];
    
}
- (void)backClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //1.获取随机的54张牌
    NSArray *allPokerArr = [self getArcrandomAllPokers];
    //2.把牌分配给所有人
    [self orderDistributionAllPokers:allPokerArr];//顺序发牌
}

#pragma mark- 数据处理
- (NSArray *)getArcrandomAllPokers{//洗牌操作
    return [self.firstPokerArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int seed = arc4random_uniform(2);//取值0、1
        if (seed) {
            return [obj1 compare:obj2];//-1左小、1右小
        } else {
            return [obj2 compare:obj1];//-1左小、1右小
        }
    }];
}
- (NSArray *)firstPokerArr{//初始的扑克牌
    if (!_firstPokerArr) {
        //按大小王-黑红梅方-从2到3 的顺序排列所有的54张牌
        NSArray *colorArr = @[@"1",@"2",@"3",@"4"];//花色:1黑、2红、3梅、4方
       //牌面数字替代：2-02、A-03、K-04、Q-05、J-06、10-07、9-08、8-09、7-10、6-11、5-12、4-13、3-14
        NSArray *numArr   = @[@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14"];//牌号
        NSMutableArray *aNewPokerArr = [NSMutableArray arrayWithArray:@[@"000",@"010"]];//@[@"大王",@"小王"]
        for (NSString *numStr in numArr) {//组合不同花色不同数字的牌
            for (NSString *colorStr in colorArr) {
                NSString *nameStr = [numStr stringByAppendingString:colorStr];//前两位为牌面数字、最后一位为花色
                [aNewPokerArr addObject:nameStr];
            }
        }
        _firstPokerArr = aNewPokerArr.copy;
    }
    return _firstPokerArr;
}
- (void)orderDistributionAllPokers:(NSArray *)allPokerArr{//顺序发牌
    //一张一张的把牌分别发给3个人，最后3张牌作为底牌
    NSMutableArray *oneArrM = [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *twoArrM = [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *threeArrM = [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *botArrM = [NSMutableArray arrayWithCapacity:3];
    int whoTag = 1;//先从第1个人开始发牌
    for (int i = 0; i < allPokerArr.count; ++i) {
        NSString *str = allPokerArr[i];
        if (i > allPokerArr.count -4) {//3张底牌
            [botArrM addObject:str];
            NSArray *sortBotArr =[botArrM.copy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//插入的时候就排序
                NSComparisonResult result = [obj1 compare: obj2];//obj1比obj2小
                return result;
            }];
            botArrM = [sortBotArr mutableCopy];
            _botLab.text =[self pingStrWithArr:sortBotArr];
        }else if (whoTag == 1) {//第一个人的牌
            [oneArrM addObject:str];
            NSArray *sortOneArr = [oneArrM.copy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//插入的时候就排序
                NSComparisonResult result = [obj1 compare: obj2];//obj1比obj2小
                return result;
            }];
            oneArrM = [sortOneArr mutableCopy];
            _oneLab.text =[self pingStrWithArr:sortOneArr];
            whoTag = 2;
        }else if (whoTag == 2) {//第二个人的牌
            [twoArrM addObject:str];
            NSArray *sortTwoArr =[twoArrM.copy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//插入的时候就排序
                NSComparisonResult result = [obj1 compare: obj2];//obj1比obj2小
                return result;
            }];
            twoArrM = [sortTwoArr mutableCopy];
            _twoLab.text =[self pingStrWithArr:sortTwoArr];
            whoTag = 3;
        }else if (whoTag == 3) {//第三个人的牌
            [threeArrM addObject:str];
            NSArray *sortThreeArr = [threeArrM.copy sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {//插入的时候就排序
                NSComparisonResult result = [obj1 compare: obj2];//obj1比obj2小
                return result;
            }];
            threeArrM = [sortThreeArr mutableCopy];
            _threeLab.text =[self pingStrWithArr:sortThreeArr];
            whoTag = 1;
        }
    }
}

#pragma mark- 展示出每个人的牌（调试用）
- (NSString *)pingStrWithArr:(NSArray *)arr{//把每个人的牌拼接成字符串
    NSString *arrStr = @"";
    for (NSString *str in arr) {
        arrStr = [arrStr stringByAppendingString:[NSString stringWithFormat:@"%@  ",str]];
    }
    return arrStr;
}


@end
