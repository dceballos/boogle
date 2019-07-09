//
//  ViewController.m
//  Boogle
//
//  Created by Daniel Ceballos on 7/7/19.
//  Copyright © 2019 Boogie. All rights reserved.
//

#import "ViewController.h"
#import "BoogleGridView.h"
#import "BoogleDiceView.h"

#define kBoogleRows 4
#define kBoogleCols 4
#define kBoogleGameMinutes 3

@interface ViewController () {
  NSMutableSet       *words;
  NSMutableString    *word;
  UIBezierPath       *wordPath;
  BoogleDiceView     *previousView;
  BoogleDiceView     *currentView;
  NSTimer            *timer;
  NSArray            *dies;
  NSMutableArray     *lineLayers;
  NSMutableArray     *sessionDice;
  NSLayoutConstraint *gridViewHeightConstraint;
  NSLayoutConstraint *gridViewWidthConstraint;
  NSLayoutConstraint *gridViewXConstraint;
  NSLayoutConstraint *gridViewYConstraint;
  NSLayoutConstraint *finishViewHeightConstraint;
  NSLayoutConstraint *finishViewWidthConstraint;
  NSLayoutConstraint *finishViewXConstraint;
  NSLayoutConstraint *finishViewYConstraint;
  NSLayoutConstraint *timerLabelHeightConstraint;
  NSLayoutConstraint *timerLabelWidthConstraint;
  NSLayoutConstraint *timerLabelXConstraint;
  NSLayoutConstraint *timerLabelYConstraint;
  NSLayoutConstraint *titleLabelHeightConstraint;
  NSLayoutConstraint *titleLabelWidthConstraint;
  NSLayoutConstraint *titleLabelXConstraint;
  NSLayoutConstraint *titleLabelYConstraint;
  NSLayoutConstraint *startLabelHeightConstraint;
  NSLayoutConstraint *startLabelWidthConstraint;
  NSLayoutConstraint *startLabelXConstraint;
  NSLayoutConstraint *startLabelYConstraint;
  NSLayoutConstraint *wordCountLabelHeightConstraint;
  NSLayoutConstraint *wordCountLabelWidthConstraint;
  NSLayoutConstraint *wordCountLabelXConstraint;
  NSLayoutConstraint *wordCountLabelYConstraint;
}

@property (nonatomic) BoogleGridView *gridView;
@property (nonatomic) UIView         *finishView;
@property (nonatomic) UILabel        *timerLabel;
@property (nonatomic) UILabel        *titleLabel;
@property (nonatomic) UILabel        *startLabel;
@property (nonatomic) UILabel        *wordCountLabel;
@property (nonatomic) UILabel        *pointsLabel;
@property (nonatomic) UILabel        *messagesLabel;

@end

@implementation ViewController

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (motion == UIEventSubtypeMotionShake) {
    [self rollAndDisplay];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  lineLayers = @[].mutableCopy;
  self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
  [self initAndSetGridView];
  [self initAndSetTitleLabel];
  [self initAndSetFinishView];
  [self initAndSetStartLabel];
  [self initAndSetTimerLabel];
  [self initAndSetWordCountLabel];
}

- (void)initAndSetTitleLabel {
  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.titleLabel.backgroundColor = [UIColor clearColor];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:34];
  self.titleLabel.text = @"Boogle";
  [self.view addSubview:self.titleLabel];
  [self.view addConstraints:@[
    [self titleLabelWidthConstraint],[self titleLabelHeightConstraint],
    [self titleLabelYConstraint], [self titleLabelXConstraint]
  ]];
}

- (void)initAndSetTimerLabel {
  self.timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.timerLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.timerLabel.backgroundColor = [UIColor clearColor];
  self.timerLabel.textAlignment = NSTextAlignmentCenter;
  self.timerLabel.font = [UIFont fontWithName:@"Avenir-Light" size:28];
  [self.view addSubview:self.timerLabel];
  [self.view addConstraints:@[
    [self timerLabelWidthConstraint],[self timerLabelHeightConstraint],
    [self timerLabelYConstraint], [self timerLabelXConstraint]
  ]];
}

- (void)initAndSetWordCountLabel {
  self.wordCountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.wordCountLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.wordCountLabel.backgroundColor = [UIColor clearColor];
  self.wordCountLabel.textAlignment = NSTextAlignmentCenter;
  self.wordCountLabel.font = [UIFont fontWithName:@"Avenir-Light" size:22];
  [self.view addSubview:self.wordCountLabel];
  [self.view addConstraints:@[
  [self wordCountLabelWidthConstraint],[self wordCountLabelHeightConstraint],
                              [self wordCountLabelYConstraint], [self wordCountLabelXConstraint]
                              ]];
}

- (void)initAndSetStartLabel {
  self.startLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  self.startLabel.translatesAutoresizingMaskIntoConstraints = NO;
  self.startLabel.backgroundColor = [UIColor clearColor];
  self.startLabel.textColor = [UIColor whiteColor];
  self.startLabel.textAlignment = NSTextAlignmentCenter;
  self.startLabel.font = [UIFont fontWithName:@"Avenir-LightOblique" size:28];
  self.startLabel.text = @"Shake to start!";
  [self.finishView addSubview:self.startLabel];
  [self.finishView addConstraints:@[
    [self startLabelWidthConstraint],[self startLabelHeightConstraint],
    [self startLabelYConstraint], [self startLabelXConstraint]
  ]];
}

- (void)initAndSetGridView {
  self.gridView = [[BoogleGridView alloc] initWithFrame:CGRectZero];
  self.gridView.delegate = self;
  self.gridView.translatesAutoresizingMaskIntoConstraints = NO;
  self.gridView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.gridView];
  [self.view addConstraints:@[
    [self gridViewWidthConstraint],[self gridViewHeightConstraint],
    [self gridViewYConstraint], [self gridViewXConstraint]
  ]];
}

- (void)initAndSetFinishView {
  self.finishView = [[UIView alloc] initWithFrame:CGRectZero];
  self.finishView.translatesAutoresizingMaskIntoConstraints = NO;
  self.finishView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
  [self.view addSubview:self.finishView];
  [self.view addConstraints:@[
    [self finishViewWidthConstraint],[self finishViewHeightConstraint],
    [self finishViewYConstraint], [self finishViewXConstraint]
  ]];
}

- (id)rollAndDisplay {
  words = [NSSet setWithArray:@[]].mutableCopy;
  self.wordCountLabel.text = @"";
  self.finishView.hidden = YES;
  [self roll];
  [self display];
  [self startTimer];
  return nil;
}

- (id)roll {
  sessionDice = @[].mutableCopy;
  for (int i=0;i<(kBoogleRows*kBoogleCols);i++) {
    sessionDice[i] = [self dies][i][arc4random()%kBoogleCols];
  }
  NSUInteger count = [sessionDice count];
  for (NSUInteger i = 0; i < count - 1; ++i) {
    NSUInteger nElements = count - i;
    NSUInteger n = arc4random_uniform(nElements) + i;
    [sessionDice exchangeObjectAtIndex:i withObjectAtIndex:n];
  }
  return nil;
}

- (void)clear {
  for (UIView *v in [self.gridView subviews]) {
    [v removeFromSuperview];
  }
}

- (void)display {
  [self clearLines];
  [self clear];
  NSUInteger len = [self cellLen];
  for (int r=0;r<(kBoogleRows);r++) {
    for (int s=0;s<(kBoogleCols);s++) {
      NSUInteger hoffset = ((s+1)*len)-len;
      NSUInteger voffset = ((r+1)*len)-len;
      CGRect frame = CGRectMake(hoffset, voffset, len, len);
      BoogleDiceView *diceView = [[BoogleDiceView alloc] initWithFrame:frame];
      NSUInteger diceIndex = [self diceIndexForRow:r col:s];
      NSString *letter = [NSString stringWithFormat:@"%@", sessionDice[diceIndex]];
      diceView.letter.text = letter;
      [self.gridView addSubview:diceView];
    }
  }
}

- (void)startTimer {
  if (timer != nil) {
    [timer invalidate];
    timer = nil;
  }
  [self displayTime:0];
  NSTimeInterval start = CFAbsoluteTimeGetCurrent();
  timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:(void (^)(NSTimer *timer))^{
    NSTimeInterval current = CFAbsoluteTimeGetCurrent();
    float elapsed = current-start;
    if (elapsed >= kBoogleGameMinutes*60) {
      elapsed = kBoogleGameMinutes*60;
      [self->timer invalidate];
      self.finishView.hidden = NO;
    }
    [self displayTime:elapsed];
  }];
  [timer fire];
}

- (void)displayTime:(float)elapsed {
  float timeLeft  = (kBoogleGameMinutes*60.0) - elapsed;
  int minutes     = floor(timeLeft/60.0);
  int seconds     = floor(((timeLeft/60.0)-minutes)*60);
  //NSLog(@"%d %d %f %f", minutes, seconds, timeLeft, elapsed);
  self.timerLabel.text = [NSString stringWithFormat:@"%d:%02d",minutes,seconds];
}

- (NSArray*)dies {
  if (dies != nil) {
    return dies;
  }
  dies = @[
    @[@"R",@"I",@"F",@"O",@"B",@"X"],
    @[@"I",@"F",@"E",@"H",@"E",@"Y"],
    @[@"D",@"E",@"N",@"O",@"W",@"S"],
    @[@"U",@"T",@"O",@"K",@"N",@"D"],
    @[@"H",@"M",@"S",@"R",@"A",@"O"],
    @[@"L",@"U",@"P",@"E",@"T",@"S"],
    @[@"A",@"C",@"I",@"T",@"O",@"A"],
    @[@"Y",@"L",@"G",@"K",@"U",@"E"],
    @[@"Qu",@"B",@"M",@"J",@"O",@"A"],
    @[@"E",@"H",@"I",@"S",@"P",@"N"],
    @[@"V",@"E",@"T",@"I",@"G",@"N"],
    @[@"B",@"A",@"L",@"I",@"Y",@"T"],
    @[@"E",@"Z",@"A",@"V",@"N",@"D"],
    @[@"R",@"A",@"L",@"E",@"S",@"C"],
    @[@"U",@"W",@"I",@"L",@"R",@"G"],
    @[@"P",@"A",@"C",@"E",@"M",@"D"]];
  return dies;
}

- (NSInteger)cellLen {
  return self.view.frame.size.width/kBoogleCols;
}

- (NSInteger)diceIndexForRow:(NSUInteger)row col:(NSUInteger)col {
  return ((row+1)*kBoogleCols)-(col+1);
}

// Constraints
- (NSLayoutConstraint*)gridViewWidthConstraint {
  if (gridViewWidthConstraint == nil) {
    gridViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.gridView
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.gridView
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:0
                                                              constant:[self cellLen]*kBoogleCols];
  }
  return gridViewWidthConstraint;
}

- (NSLayoutConstraint*)gridViewHeightConstraint {
  if (gridViewHeightConstraint == nil) {
    gridViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.gridView
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.gridView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:0
                                                               constant:[self cellLen]*kBoogleRows];
  }
  return gridViewHeightConstraint;
}

- (NSLayoutConstraint*)gridViewXConstraint {
  if (gridViewXConstraint == nil) {
    gridViewXConstraint = [NSLayoutConstraint constraintWithItem:self.gridView
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0];
  }
  return gridViewXConstraint;
}

- (NSLayoutConstraint*)gridViewYConstraint {
  if (gridViewYConstraint == nil) {
    gridViewYConstraint = [NSLayoutConstraint constraintWithItem:self.gridView
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0];
  }
  return gridViewYConstraint;
}

- (NSLayoutConstraint*)finishViewWidthConstraint {
  if (finishViewWidthConstraint == nil) {
    finishViewWidthConstraint = [NSLayoutConstraint constraintWithItem:self.finishView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.gridView
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0];
  }
  return finishViewWidthConstraint;
}

- (NSLayoutConstraint*)finishViewHeightConstraint {
  if (finishViewHeightConstraint == nil) {
    finishViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.finishView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.gridView
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:0];
  }
  return finishViewHeightConstraint;
}

- (NSLayoutConstraint*)finishViewXConstraint {
  if (finishViewXConstraint == nil) {
    finishViewXConstraint = [NSLayoutConstraint constraintWithItem:self.finishView
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.gridView
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1
                                                        constant:0];
  }
  return finishViewXConstraint;
}

- (NSLayoutConstraint*)finishViewYConstraint {
  if (finishViewYConstraint == nil) {
    finishViewYConstraint = [NSLayoutConstraint constraintWithItem:self.finishView
                                                       attribute:NSLayoutAttributeCenterY
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.gridView
                                                       attribute:NSLayoutAttributeCenterY
                                                      multiplier:1
                                                        constant:0];
  }
  return finishViewYConstraint;
}

- (NSLayoutConstraint*)timerLabelWidthConstraint {
  if (timerLabelWidthConstraint == nil) {
    timerLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.timerLabel
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:0
                                                            constant:[self cellLen]*kBoogleCols];
  }
  return timerLabelWidthConstraint;
}

- (NSLayoutConstraint*)timerLabelHeightConstraint {
  if (timerLabelHeightConstraint == nil) {
    timerLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.timerLabel
                                                            attribute:NSLayoutAttributeHeight
                                                           multiplier:1
                                                             constant:0];
  }
  return timerLabelHeightConstraint;
}

- (NSLayoutConstraint*)timerLabelXConstraint {
  if (timerLabelXConstraint == nil) {
    timerLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel
                                                       attribute:NSLayoutAttributeCenterX
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.view
                                                       attribute:NSLayoutAttributeCenterX
                                                      multiplier:1
                                                        constant:0];
  }
  return timerLabelXConstraint;
}

- (NSLayoutConstraint*)timerLabelYConstraint {
  if (timerLabelYConstraint == nil) {
    timerLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.timerLabel
                                                       attribute:NSLayoutAttributeTop
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:self.gridView
                                                       attribute:NSLayoutAttributeBottom
                                                      multiplier:1
                                                        constant:30];
  }
  return timerLabelYConstraint;
}

- (NSLayoutConstraint*)titleLabelWidthConstraint {
  if (titleLabelWidthConstraint == nil) {
    titleLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.titleLabel
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:0
                                                              constant:[self cellLen]*kBoogleCols];
  }
  return titleLabelWidthConstraint;
}

- (NSLayoutConstraint*)titleLabelHeightConstraint {
  if (titleLabelHeightConstraint == nil) {
    titleLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.titleLabel
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:0];
  }
  return titleLabelHeightConstraint;
}

- (NSLayoutConstraint*)titleLabelXConstraint {
  if (titleLabelXConstraint == nil) {
    titleLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0];
  }
  return titleLabelXConstraint;
}

- (NSLayoutConstraint*)titleLabelYConstraint {
  if (titleLabelYConstraint == nil) {
    titleLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.titleLabel
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.gridView
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:-100];
  }
  return titleLabelYConstraint;
}

- (NSLayoutConstraint*)startLabelWidthConstraint {
  if (startLabelWidthConstraint == nil) {
    startLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.startLabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.startLabel
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:0
                                                              constant:[self cellLen]*kBoogleCols];
  }
  return startLabelWidthConstraint;
}

- (NSLayoutConstraint*)startLabelHeightConstraint {
  if (startLabelHeightConstraint == nil) {
    startLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.startLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.startLabel
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:0
                                                               constant:100];
  }
  return startLabelHeightConstraint;
}

- (NSLayoutConstraint*)startLabelXConstraint {
  if (startLabelXConstraint == nil) {
    startLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.startLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.finishView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0];
  }
  return startLabelXConstraint;
}

- (NSLayoutConstraint*)startLabelYConstraint {
  if (startLabelYConstraint == nil) {
    startLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.startLabel
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.finishView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0];
  }
  return startLabelYConstraint;
}

- (NSLayoutConstraint*)wordCountLabelWidthConstraint {
  if (wordCountLabelWidthConstraint == nil) {
    wordCountLabelWidthConstraint = [NSLayoutConstraint constraintWithItem:self.wordCountLabel
                                                             attribute:NSLayoutAttributeWidth
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.wordCountLabel
                                                             attribute:NSLayoutAttributeWidth
                                                            multiplier:0
                                                              constant:[self cellLen]*kBoogleCols];
  }
  return wordCountLabelWidthConstraint;
}

- (NSLayoutConstraint*)wordCountLabelHeightConstraint {
  if (wordCountLabelHeightConstraint == nil) {
    wordCountLabelHeightConstraint = [NSLayoutConstraint constraintWithItem:self.wordCountLabel
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.wordCountLabel
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1
                                                               constant:0];
  }
  return wordCountLabelHeightConstraint;
}

- (NSLayoutConstraint*)wordCountLabelXConstraint {
  if (wordCountLabelXConstraint == nil) {
    wordCountLabelXConstraint = [NSLayoutConstraint constraintWithItem:self.wordCountLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.view
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0];
  }
  return wordCountLabelXConstraint;
}

- (NSLayoutConstraint*)wordCountLabelYConstraint {
  if (wordCountLabelYConstraint == nil) {
    wordCountLabelYConstraint = [NSLayoutConstraint constraintWithItem:self.wordCountLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.timerLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1
                                                          constant:40];
  }
  return wordCountLabelYConstraint;
}

// Grid View Helper Methods
- (BoogleDiceView*)diceViewForGridViewLocation:(CGPoint)location {
  BoogleDiceView *view = (BoogleDiceView*)[self.gridView hitTest:(CGPoint)location withEvent:nil];
  if (view) {
    CGPoint localPoint = [self.gridView convertPoint:location toView:view];
    if (CGRectContainsPoint(CGRectInset(view.bounds, 15, 15), localPoint)) {
      return view;
    }
  }
  return nil;
}

- (void)drawLine:(UIBezierPath*)path {
  //design path in layer
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  shapeLayer.path = [path CGPath];
  shapeLayer.strokeColor = [[UIColor redColor] CGColor];
  shapeLayer.lineWidth = 5.0;
  [self.gridView.layer addSublayer:shapeLayer];
  [lineLayers addObject:shapeLayer];
}

- (void)clearLines {
  for (int i=0;i<[lineLayers count];i++) {
    CALayer *layer = lineLayers[i];
    [layer removeFromSuperlayer];
  }
  [lineLayers removeAllObjects];
}

// Grid View Delegates
- (void)gridViewTouchesBegan:(CGPoint)touchLocation {
  BoogleDiceView* view = [self diceViewForGridViewLocation:touchLocation];
  if (view) {
    currentView = view;
    word        = view.letter.text.mutableCopy;
    wordPath    = [UIBezierPath bezierPath];
    [wordPath moveToPoint:view.center];
  }
}

- (void)gridViewTouchesEnded:(CGPoint)touchLocation {
  [self clearLines];
  if ([word length] < 3) {
    NSLog(@"%@ too short!", word);
  }else if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:word]) {
    if (![words containsObject:word]) {
      [words addObject:word];
      NSLog(@"%@ added! %ld points", word, [word length]);
    }else{
      NSLog(@"%@ exists!", word);
    }
  }else{
    NSLog(@"%@ is not a word", word);
  }
  self.wordCountLabel.text = [NSString stringWithFormat:@"%ld words", [words count]];
  previousView = nil;
  currentView  = nil;
}

- (void)gridViewTouchesMoved:(CGPoint)touchLocation {
  BoogleDiceView* view = [self diceViewForGridViewLocation:touchLocation];
  if (view) {
    if (view != currentView) {
      previousView = currentView;
      currentView = view;
      [word appendString:view.letter.text];
      [wordPath addLineToPoint:view.center];
      [self drawLine:wordPath];
      wordPath    = [UIBezierPath bezierPath];
      [wordPath moveToPoint:view.center];
      NSLog(@"%@", word);
    }
  }
}
- (void)gridViewTouchesCancelled:(CGPoint)touchLocation {
  previousView = nil;
  currentView  = nil;
}
@end
