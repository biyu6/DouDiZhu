//
//  BYEasyVC.m
//  doudizhu
//
//  Created by 胡忠诚 on 2018/4/16.
//  Copyright © 2018年 biyu6. All rights reserved.
//

#import "BYEasyVC.h"

@interface BYEasyVC ()
/**初始的扑克牌*/
@property (nonatomic, strong)NSArray *firstPokerArr;

@end
@implementation BYEasyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, 80, 30)];
    backBtn.backgroundColor = [UIColor blueColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];

    
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
- (NSArray *)firstPokerArr{//初始的扑克牌
    if (!_firstPokerArr) {
        //按大小王-黑红梅方-从2到3 的顺序排列所有的54张牌
        NSArray *colorArr = @[@"黑",@"红",@"梅",@"方"];//花色
        NSArray *numArr   = @[@"2",@"A",@"K",@"Q",@"J",@"10",@"9",@"8",@"7",@"6",@"5",@"4",@"3"];//牌号
        NSMutableArray *aNewPokerArr = [NSMutableArray arrayWithArray:@[@"大王",@"小王"]];
        for (NSString *numStr in numArr) {//组合不同花色不同数字的牌
            for (NSString *colorStr in colorArr) {
                NSString *nameStr = [colorStr stringByAppendingString:numStr];
                [aNewPokerArr addObject:nameStr];
            }
        }
        _firstPokerArr = aNewPokerArr.copy;
    }
    return _firstPokerArr;
}
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
- (void)orderDistributionAllPokers:(NSArray *)allPokerArr{//顺序发牌
    //一张一张的把牌分别发给3个人，最后3张牌作为底牌
    NSMutableArray *oneArrM = [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *twoArrM = [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *threeArrM = [NSMutableArray arrayWithCapacity:17];
    NSMutableArray *botArrM = [NSMutableArray arrayWithCapacity:3];
    int whoTag = 1;
    for (int i = 0; i < allPokerArr.count; ++i) {
        NSString *str = allPokerArr[i];
        if (i > allPokerArr.count -4) {//3张底牌
            [botArrM addObject:str];
        }else if (whoTag == 1) {//第一个人的牌
            [oneArrM addObject:str];
            whoTag = 2;
        }else if (whoTag == 2) {//第二个人的牌
            [twoArrM addObject:str];
            whoTag = 3;
        }else if (whoTag == 3) {//第三个人的牌
            [threeArrM addObject:str];
            whoTag = 1;
        }
    }
    //将所有人的牌都排好序
    NSArray *onePokerArr = [self sortMyPokers:oneArrM.copy allPokers:self.firstPokerArr];
    NSArray *twoPokerArr = [self sortMyPokers:twoArrM.copy allPokers:self.firstPokerArr];
    NSArray *threePokerArr = [self sortMyPokers:threeArrM.copy allPokers:self.firstPokerArr];
    NSArray *botPokerArr = [self sortMyPokers:botArrM allPokers:self.firstPokerArr];
    NSLog(@"排序后的牌：第一位：%@ \n 第二位：%@ \n 第三位：%@ \n 底牌：%@",onePokerArr,twoPokerArr,threePokerArr,botPokerArr);
    //展示出每个人的牌（调试用）
    [self onceOneCards:onePokerArr twoCards:twoPokerArr threeCards:threePokerArr botCards:botPokerArr];
}
- (NSArray *)sortMyPokers:(NSArray *)myPokerArr allPokers:(NSArray *)allPokerArr{//对手里的牌排序：遍历排序好的54张牌数组，将不是我的牌剔除
    NSMutableArray *resultArr = [NSMutableArray arrayWithArray:allPokerArr];
    for (NSString *str in allPokerArr) {
        if (![myPokerArr containsObject:str]) {//如果有牌不在我手中，就剔除
            [resultArr removeObject:str];
        }
    }
    return resultArr;
}

#pragma mark- 展示出每个人的牌（调试用）
- (void)onceOneCards:(NSArray *)oneCardArr twoCards:(NSArray *)twoCardArr threeCards:(NSArray *)threeCardArr botCards:(NSArray *)botCardArr{
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
    
    UILabel *botLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 430, 300, 100)];//底牌
    botLab.backgroundColor = [UIColor cyanColor];
    botLab.numberOfLines = 0;
    [self.view addSubview:botLab];
    
    oneLab.text = [self pingStrWithArr:oneCardArr];
    twoLab.text = [self pingStrWithArr:twoCardArr];
    threeLab.text = [self pingStrWithArr:threeCardArr];
    botLab.text = [self pingStrWithArr:botCardArr];
}
- (NSString *)pingStrWithArr:(NSArray *)arr{//把每个人的牌拼接成字符串
    NSString *arrStr = @"";
    for (NSString *str in arr) {
        arrStr = [arrStr stringByAppendingString:[NSString stringWithFormat:@"%@  ",str]];
    }
    return arrStr;
}


@end
