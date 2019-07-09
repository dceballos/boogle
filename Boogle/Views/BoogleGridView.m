//
//  BoogleGridView.m
//  Boogle
//
//  Created by Daniel Ceballos on 7/9/19.
//  Copyright © 2019 Boogie. All rights reserved.
//

#import "BoogleGridView.h"

@implementation BoogleGridView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)touchesBegan:(NSSet *)touch withEvent:(UIEvent *)event {
  UITouch *touches = [[event allTouches] anyObject];
  CGPoint touchLocation = [touches locationInView:self];
  if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewTouchesBegan:)]) {
    [self.delegate gridViewTouchesBegan:touchLocation];
  }
}

- (void)touchesEnded:(NSSet *)touch withEvent:(UIEvent *)event {
  UITouch *touches = [[event allTouches] anyObject];
  CGPoint touchLocation = [touches locationInView:self];
  if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewTouchesEnded:)]) {
    [self.delegate gridViewTouchesEnded:touchLocation];
  }
}

- (void)touchesCancelled:(NSSet *)touch withEvent:(UIEvent *)event {
  UITouch *touches = [[event allTouches] anyObject];
  CGPoint touchLocation = [touches locationInView:self];
  if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewTouchesCancelled:)]) {
    [self.delegate gridViewTouchesCancelled:touchLocation];
  }
}

- (void)touchesMoved:(NSSet *)touch withEvent:(UIEvent *)event {
  UITouch *touches = [[event allTouches] anyObject];
  CGPoint touchLocation = [touches locationInView:self];
  if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewTouchesMoved:)]) {
    [self.delegate gridViewTouchesMoved:touchLocation];
  }
}

@end
