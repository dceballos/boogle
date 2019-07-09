//
//  BoogleGridView.h
//  Boogle
//
//  Created by Daniel Ceballos on 7/9/19.
//  Copyright © 2019 Boogie. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BoogleGridView : UIView

@property (nonatomic) id delegate;

@end

@protocol BoogleGridViewDelegate <NSObject>
- (void)gridViewTouchesBegan:(CGPoint)touchLocation;
- (void)gridViewTouchesEnded:(CGPoint)touchLocation;
- (void)gridViewTouchesMoved:(CGPoint)touchLocation;
- (void)gridViewTouchesCancelled:(CGPoint)touchLocation;
@end

NS_ASSUME_NONNULL_END
