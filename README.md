#斗地主的发牌及排序

### 闲来无聊的小程序，有这么几个功能：
##### 1.初始牌：按现实中一副新的扑克牌的顺序生成一个初始的扑克牌数组
##### 2.洗牌：把54张牌乱序
##### 3.把牌一张一张的按照乱序后的顺序发给三个人，最后三张作为底牌
##### 4.每发一张牌就把每个人手中的牌按大小排序

### 主要代码如下：
```
//初始的扑克牌
- (NSArray *)firstPokerArr{
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

//洗牌操作
- (NSArray *)getArcrandomAllPokers{
    return [self.firstPokerArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int seed = arc4random_uniform(2);//取值0、1
        if (seed) {
            return [obj1 compare:obj2];//-1左小、1右小
        } else {
            return [obj2 compare:obj1];//-1左小、1右小
        }
    }];
}

//按顺序发牌：
	代码见Demo


````

![image](https://github.com/biyu6/DouDiZhu/blob/master/one.png)
![image](https://github.com/biyu6/DouDiZhu/blob/master/two.png)
