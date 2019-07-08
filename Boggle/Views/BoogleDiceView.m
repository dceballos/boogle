//
//  BoogleCollectionViewCell.m
//  Boggle
//
//  Created by Daniel Ceballos on 7/7/19.
//  Copyright © 2019 Boogie. All rights reserved.
//

#import "BoogleDiceView.h"

@implementation BoogleDiceView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.letter = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    self.letter.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.letter.font = [UIFont boldSystemFontOfSize:34];
    self.letter.textColor = [UIColor blackColor];
    self.letter.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.letter];
  }
  return self;
}
@end
