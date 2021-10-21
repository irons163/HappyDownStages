//
//  M     yScene.m
//  Try_downStage
//
//  Created by irons on 2015/4/22.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "ToolUtil.h"
#import "Footboard.h"
#import "MyUtils.h"
#import "CommonUtil.h"
#import "FireBall.h"
#import "TextureHelper.h"
#import "GameCenterUtil.h"
#import "MyADView.h"

const int stay = 0;
const int left = 1;
const int right = 2;



@implementation MyScene{
    BitmapUtil * bitmapUtil;
    CommonUtil * commonUtil;
    SKTexture * background; // 背景圖
    int height, width; // 螢幕高寬
    float firstBgHeight; // 第一張背景圖的座標X
    float secondBgHeight; // 第二背景圖的座標X
    int footboardHeight, footboardWidth; // 地板高寬
    Player * player; // 玩家
    float BASE_SPEED;
    float SPEED; // 背景每次上升距離
    bool playerDownOnFootBoard; // 玩家是否著地。一開始玩家就是在地板上，因此初始為否。
    bool playerStandOnFootboard;
    bool readyFlag;
    int readyStep;
    float playerWalkSpeed;
    //    Controler controler;
    int whichFoorbar;
    int count;
    int level;
    bool gameSuccess;
    int move;
    bool isPressLeftMoveBtn, isPressRightMoveBtn;
    //    const Object CREATE_FOOTBAR_LOCK = new Object();
    
    int SCORE_MULTIPLE;
    float DOWNSPEED; // 墜落距離
    
    bool isGameFinish;
    
    //    int key;
    bool isMoving;
    
    NSTimer * theGameTimer, * theReadyTimer;
    
    NSMutableArray * currentXs;
    NSMutableArray * footboards;
    NSMutableArray * footboardsTheSameLine;
    Footboard* footboard;
    NSMutableArray * fireballs;
    
    NSMutableArray * ramdonBackgroundID;
    
    SKSpriteNode * backgroundNode, * secondBackgroundNode;
    SKSpriteNode* topSpikedBar;
    SKSpriteNode * floor;
    NSMutableArray * floorArray;
    SKSpriteNode * bomb;
    SKSpriteNode * heal;
    SKSpriteNode * tree;
    FireBall * fireBall;
    SKSpriteNode * sharp;
    SKSpriteNode * hpBar;
    SKSpriteNode * redNode;
    SKSpriteNode* life_bgNode;
    SKSpriteNode* lifeNode;
    SKLabelNode* readyLabel;
    SKLabelNode* theGameTimerLabel;
    
    SKSpriteNode * leftKey;
    SKSpriteNode * rightKey;
    
    NSMutableArray* timers;
    
    MyADView * myAdView;
}

static float MOVESPEED; // 每次左右移動距離

static bool gameFlag = true;


static bool gameStop;

static int LEFT;
static int RIGHT;
static SKTexture* nextBackground;

static const int GAME_TIME = 60;
//	final static int FOOTBOARD_HRIGHT_PERSENT = 20;
static const int FOOTBOARD_WIDTH_PERSENT = 4;

static ToolUtil* toolExplodingUtil;

static const int SMOOTH_DEVIATION = 2;

int currentX = 200;

//int DISTANCE_MULTIPLE = 10;
int DISTANCE_MULTIPLE = 10;

int MINIMUM_DISTANCE_BETWEEN_FOOTBOARDS = 30;

int life;

- (void)handler:(int)what {
    if (what == 0) {
        gameFlag = false;
        
        if (!gameSuccess) {
            [self submitScore];
        } else {
            int maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
            if (maxLevel < INFINITY_LEVEL && level >= maxLevel) {
                int lv = maxLevel + 1;
                [[NSUserDefaults standardUserDefaults] setInteger:lv forKey:@"level"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [self.gameDelegate showWinDialog];
        }
    }
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    self.view.multipleTouchEnabled = YES;
}

- (void)submitScore {
    const int score = GAME_TIME * level * SCORE_MULTIPLE + count * SCORE_MULTIPLE;
    
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil reportScore:score forCategory:@"com.irons.HappyDownStages"];
    
    [self.gameDelegate showLoseDialog:score];
}

- (NSString *)getRandomBgResId {
    int index = arc4random_uniform(3);
    return ramdonBackgroundID[index];
}

- (void)initGame {
    commonUtil = [CommonUtil sharedInstance];
    bitmapUtil = [BitmapUtil sharedInstance];
    BASE_SPEED = (float)((BitmapUtil *)[BitmapUtil sharedInstance]).sreenWidth / 20;
    SPEED = BASE_SPEED;
    playerDownOnFootBoard = false;
    playerStandOnFootboard = false;
    readyFlag = true;
    readyStep = 0;
    playerWalkSpeed = 0;
    whichFoorbar = 0;
    count = 0;
    gameSuccess = false;
    move = 0;
    SCORE_MULTIPLE = 100;
    //    DOWNSPEED = BASE_SPEED*5;
    DOWNSPEED = BASE_SPEED;
    
    commonUtil.SLIDERSPEED = (float)((BitmapUtil *)[BitmapUtil sharedInstance]).sreenWidth / 90;
    MOVESPEED = commonUtil.SLIDERSPEED * 3 + level * 0.6;
    
    gameStop = false;
    LEFT = 1;
    RIGHT = 2;
    
    isMoving = false;
    
    currentXs = [NSMutableArray array];
    footboards = [NSMutableArray array];
    footboardsTheSameLine = [NSMutableArray array];
    fireballs = [NSMutableArray array];
    ramdonBackgroundID = [NSMutableArray array];
    timers = [NSMutableArray array];
    
    [ramdonBackgroundID addObject:@"new_bg1"];
    [ramdonBackgroundID addObject:@"new_bg2"];
    [ramdonBackgroundID addObject:@"new_bg3"];
    
    gameFlag = true;
    gameStop = false;
    
    SPEED = BASE_SPEED + level * 0.6;
    
    secondBgHeight = height;
    
    footboardWidth = (int) width / FOOTBOARD_WIDTH_PERSENT;
    footboardHeight = (int)((float)bitmapUtil.footboard_normal_bitmap.size.height
                            / bitmapUtil.footboard_normal_bitmap.size.width * footboardWidth);
    
    player = [Player spriteNodeWithTexture:nil size:CGSizeMake(width, height)];
    player.x = self.frame.size.width / 2;
    player.y = height;
    player.position = CGPointMake(self.frame.size.width/2, height);
    
    toolExplodingUtil = nil;
    
    footboard = [Footboard spriteNodeWithTexture:nil size:CGSizeMake(footboardWidth, footboardHeight)];
    [footboard setFrameX:self.frame.size.width / 2 - footboardWidth / 2 y:0 h:footboardHeight w:footboardWidth];
    footboard.anchorPoint = CGPointMake(0, 1);
    
    [footboard setWhich:0];
    [footboard setToolNum:[Footboard NOTOOL]];
    [footboardsTheSameLine addObject:footboard];
    [footboards addObject:footboardsTheSameLine];
    [currentXs addObject:[NSNumber numberWithInt:currentX]];
    
    player.y = footboard.position.y - player.size.height;
    player.position = CGPointMake(player.position.x, footboard.position.y - player.size.height + 100);
    
    nextBackground = background;
    
    backgroundNode = [SKSpriteNode spriteNodeWithTexture:nextBackground];
    backgroundNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    backgroundNode.position = CGPointMake(0, 0);
    backgroundNode.anchorPoint = CGPointMake(0, 0);
    [self addChild:backgroundNode];
    
    secondBackgroundNode = [SKSpriteNode spriteNodeWithTexture:nextBackground];
    secondBackgroundNode.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    secondBackgroundNode.position = CGPointMake(0, -self.frame.size.height);
    secondBackgroundNode.anchorPoint = CGPointMake(0, 0);
    [self addChild:secondBackgroundNode];
    
    firstBgHeight = 0;
    secondBgHeight = -height;
    
    life_bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"life_bg"];
    lifeNode = [SKSpriteNode spriteNodeWithImageNamed:@"life"];
    
    life_bgNode.size = CGSizeMake(0, 0);
    lifeNode.size = CGSizeMake(0, 0);
    
    [self addChild:life_bgNode];
    [self addChild:lifeNode];
    
    life = 90;
    
    readyLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    readyLabel.text = @"";
    readyLabel.fontSize = 30;
    readyLabel.color = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    readyLabel.position = CGPointMake(self.frame.size.width/2 - readyLabel.frame.size.width/2, self.frame.size.height/2 );
    
    [self addChild:readyLabel];
    
    
    
    player = [Player spriteNodeWithTexture:bitmapUtil.player_girl_left01_bitmap];
    player.size = bitmapUtil.player_girl_left01_size;
    player.x = self.frame.size.width/2 - player.size.width/2;
    player.y = player.size.height + 50;
    [player initPlayerX:self.frame.size.width/2 - player.size.width/2 Y:player.size.height + 50 H:0 W:0];
    player.position = CGPointMake(self.frame.size.width/2  - player.size.width/2, player.size.height + 50);
    player.anchorPoint = CGPointMake(0, 1);
    [self addChild:player];
    
    /*
     sharp = [SKSpriteNode spriteNodeWithImageNamed:@"laba_fg"];
     sharp.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
     sharp.position = CGPointMake(0, 0);
     sharp.anchorPoint = CGPointMake(0, 0);
     [self addChild:sharp];
     */
    theGameTimerLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    theGameTimerLabel.text = @"0";
    theGameTimerLabel.fontSize = 20;
    theGameTimerLabel.color = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    //    theGameTimerLabel.position = CGPointMake(self.frame.size.width/2 - readyLabel.frame.size.width/2, self.frame.size.height/2 );
    theGameTimerLabel.position = CGPointMake(0, sharp.size.height);
    
    [self addChild:theGameTimerLabel];
    theGameTimerLabel.hidden = YES;
    
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    //    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    //
    //    myLabel.text = @"Hello, World!";
    //    myLabel.fontSize = 30;
    //    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
    //                                   CGRectGetMidY(self.frame));
    //
    //    [self addChild:myLabel];
    
    redNode = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:self.frame.size];
    redNode.anchorPoint = CGPointMake(0, 0);
    redNode.hidden = YES;
    [self addChild:redNode];
    
    //    controler = new Controler(context, this.getHeight(),
    //                                   this.getWidth());
    
    leftKey = [SKSpriteNode spriteNodeWithImageNamed:@"left_keyboard_btn"];
    leftKey.size = CGSizeMake(80, 80);
    leftKey.position = CGPointMake(0, 0);
    leftKey.anchorPoint = CGPointMake(0, 0);
    
    rightKey = [SKSpriteNode spriteNodeWithImageNamed:@"right_keyboard_btn"];
    rightKey.size = CGSizeMake(80, 80);
    rightKey.position = CGPointMake(self.frame.size.width - rightKey.size.width, 0);
    rightKey.anchorPoint = CGPointMake(0, 0);
    
    [self addChild:leftKey];
    [self addChild:rightKey];
    
    [self addChild:footboard];
    
    [TextureHelper initTextures];
    [self initTimeNode];
    
    myAdView = [MyADView spriteNodeWithTexture:nil];
    myAdView.size = CGSizeMake(self.frame.size.width, 50);
    //        myAdView.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 35);
    myAdView.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - myAdView.size.height);
    [myAdView startAd];
    myAdView.zPosition = 1;
    myAdView.anchorPoint = CGPointMake(0.5, 0);
    [self addChild:myAdView];
}

+(id)sceneWihtSize:(CGSize)size withBackground:(SKTexture*)background withHeight:(int)height withWidth:(int) width withLeve:(int)level{
    MyScene * scene = [MyScene sceneWithSize:size];
    scene->background = background;
    scene->height = height;
    scene->width = width;
    scene->level = level;
    
    [scene initScene];
    
    return scene;
}

- (void)initScene {
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    SKTexture* top_spiked_bar_texture = [SKTexture textureWithImageNamed:@"top_spiked_bar"];
    topSpikedBar = [SKSpriteNode spriteNodeWithTexture:top_spiked_bar_texture];
    //			canvas.drawBitmap(bitmap, 0, 0, null);
    float topSpikedBarHeight = (float)top_spiked_bar_texture.size.height/top_spiked_bar_texture.size.width * width;
    topSpikedBar.size = CGSizeMake(width, topSpikedBarHeight);
    topSpikedBar.position = CGPointMake(0, height - topSpikedBarHeight - 50);
    topSpikedBar.anchorPoint = CGPointZero;
    topSpikedBar.zPosition = 1;
    
    [self addChild:topSpikedBar];
    
    [self initGame];
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
    }
    return self;
}

-(void)setAdClickable:(bool)clickable{
    if (myAdView!=nil) {
        [myAdView setAdClickable:clickable];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [myAdView touchesBegan:touches withEvent:event];
        
        if(CGRectContainsPoint(leftKey.calculateAccumulatedFrame, location)){
            
            isPressLeftMoveBtn = true;
            move = left;
            [player updateBitmap:LEFT];
        }else if(CGRectContainsPoint(rightKey.calculateAccumulatedFrame, location)){
            
            isPressRightMoveBtn = true;
            move = right;
            [player updateBitmap:RIGHT];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (isPressLeftMoveBtn && isPressRightMoveBtn) {
            
            if (CGRectContainsPoint(leftKey.calculateAccumulatedFrame, location)) {
                isPressLeftMoveBtn = false;
                move = right;
            } else if (CGRectContainsPoint(rightKey.calculateAccumulatedFrame, location)) {
                isPressRightMoveBtn = false;
                move = left;
            }
            
        } else if(isPressLeftMoveBtn || isPressRightMoveBtn) {
            if(CGRectContainsPoint(leftKey.calculateAccumulatedFrame, location) || CGRectContainsPoint(rightKey.calculateAccumulatedFrame, location)){
                
                if (isPressLeftMoveBtn) {
                    isPressLeftMoveBtn = !isPressLeftMoveBtn;
                } else if (isPressRightMoveBtn) {
                    isPressRightMoveBtn = !isPressRightMoveBtn;
                }
                
                [player removeAllActions];
                
                if(move == left){
                    [player updateBitmap:LEFT];
                    //                    player.texture = hamsterDefaultArray[PLAYER_STAY_LEFT_INDEX];
                }else if(move == right){
                    [player updateBitmap:RIGHT];
                    //                    player.texture = hamsterDefaultArray[PLAYER_STAY_LEFT_INDEX];
                }
                
                move = stay;
                isMoving = false;
                player.xScale = 1;
            }
        }
    }
}

int drawCount;

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //            Random r = new Random();
    
    // int i = r.nextInt(3); //隨機出現三種座標之一
    
    
    redNode.hidden = true;
    
    if(readyFlag && theReadyTimer == nil){
        [self initReadyTimer];
    }
    
    if (!gameFlag || readyFlag)
        return;
    
    if (theGameTimer == nil ){
        [self initGameTimer];
    }
    
    if (GAME_TIME - count <= 0) {
        if (level != INFINITY_LEVEL) {
            gameSuccess = true;
            [self handler:0];
        }
    }
    
    // 获取时间增量
    // 如果我们运行的每秒帧数低于60，我们依然希望一切和每秒60帧移动的位移相同
    CFTimeInterval timeSinceLast = currentTime - self.lastUpdateTimeInterval;
    self.lastUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // 如果上次更新后得时间增量大于1秒
        timeSinceLast = 1.0 / 60.0;
        self.lastUpdateTimeInterval = currentTime;
    }
    
    [self updateWithTimeSinceLastUpdate:timeSinceLast];
    
    if (life == 0 || player.position.y > height) {
        redNode.hidden = false;
        
        gameFlag = false;
        if(!isGameFinish){
            isGameFinish = true;
            [self handler:0];
        }
    }
    
    gameStop = true;
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
    self.lastSpawnTimeInterval += timeSinceLast;
    self.lastSpawnCreateFootboardTimeInterval += timeSinceLast;
    
    if (self.lastSpawnTimeInterval > 0.1) {
        self.lastSpawnTimeInterval = 0;
        
        [self draw];
    }
    
    if(self.lastSpawnCreateFootboardTimeInterval > 0.1){
        self.lastSpawnCreateFootboardTimeInterval = 0;
        int i = 0;
        drawCount++;
        
        if( drawCount % ( (int) (BASE_SPEED * 6 / SPEED) ) == 0 ){
            
            if (!gameFlag) {
                return;
            }
            
            int readyForCreateFootboardNumber = currentXs.count;
            int randomCreateNumber = arc4random_uniform(readyForCreateFootboardNumber + 1);
            randomCreateNumber++;
            
            if (randomCreateNumber > 2) randomCreateNumber = 2;
            
            footboardsTheSameLine = [NSMutableArray array];
            NSMutableArray* tempCurrentXs = [NSMutableArray array];
            
            int des = arc4random_uniform(21);
            if (des < 7) {
                des = 7;
            } else if (10 <= des && des < 18) {
                des = 18;
            }
            
            des *= DISTANCE_MULTIPLE;
            int temp = 0;
            int x = arc4random_uniform(readyForCreateFootboardNumber + 1);
            x++;
            if (x > 2) x = 2;
            
            if (x == 2 && currentXs.count == 1) {
                x = 2;
            } else if (x == 1 && currentXs.count == 1) {
                x = 1;
            } else if (x == 2 && currentXs.count == 2) {
                x = 2;
            } else if (x == 1 && currentXs.count == 2) {
                x = 1;
            }
            
            int addX=0;
            for(int number = 0; number < readyForCreateFootboardNumber; number++){
                currentX = [currentXs[number] intValue];
                
                if(number == 1 && tempCurrentXs.count > 0){
                    
                    if (addX + footboardWidth > width - footboardWidth - MINIMUM_DISTANCE_BETWEEN_FOOTBOARDS) {
                        x--;
                    }
                    
                }
                
                if (currentX < MINIMUM_DISTANCE_BETWEEN_FOOTBOARDS && x == 2) {
                    x--;
                } else if (currentX > width - footboardWidth - MINIMUM_DISTANCE_BETWEEN_FOOTBOARDS && x == 2) {
                    x--;
                }
                
                for (int k = 0 ;k < x; k++) {
                    
                    if (currentX == width - footboardWidth) {
                        
                        if (des < DISTANCE_MULTIPLE * 10) {
                            temp = -des;
                        } else {
                            temp = des - DISTANCE_MULTIPLE * 20;
                        }
                        
                    } else if (currentX == 0) {
                        
                        if (des >= DISTANCE_MULTIPLE * 10) {
                            temp = DISTANCE_MULTIPLE * 20 - des;
                        }else{
                            temp = des;
                        }
                        
                    } else {
                        
                        if (des < DISTANCE_MULTIPLE * 10) {
                            temp = -des;
                        } else {
                            temp = des - DISTANCE_MULTIPLE * 10;
                        }
                        
                    }
                    
                    if(number == 1 && tempCurrentXs.count > 0){
                        
                        if(addX + footboardWidth + MINIMUM_DISTANCE_BETWEEN_FOOTBOARDS > currentX + temp){
                            temp = abs(temp);
                        }
                        
                    }
                    
                    if (x == 2 && k == 0) {
                        temp = -abs(temp);
                    } else if(x == 2 && k == 1) {
                        temp = abs(temp);
                    }
                    
                    addX = 0;
                    if (i == 0) { // 第一種座標
                        addX = currentX + temp;
                        
                        if (addX < 0) {
                            addX = 0;
                        } else if (addX > width - footboardWidth) {
                            addX = width - footboardWidth;
                        }
                        
                        //產生地板的Y座標為螢幕下面邊緣，此方法會產生和人物交錯的現象。
                        //							footboard = new Footboard(getContext(), addX,
                        //									height-footboardHeight, footboardHeight, footboardWidth);
                        //產生地板的Y座標為螢幕下面再加一個地板高，此方法不會有人物交錯的現象，
                        //但是會有人物剛好掉在一半掉在螢幕外僥倖沒死的情況。此外，因為多往下一個地板高，
                        //所以第二個地板與第一個地板的間距會比較大，因為第一個地板預設是螢幕下面邊緣。
                        //                    footboard = new Footboard(getContext(), addX,
                        //                                              height, footboardHeight, footboardWidth);
                        
                        NSLog(@"new footboard X = %d", addX);
                        footboard = [Footboard spriteNodeWithTexture:nil];
                        [footboard setFrameX:addX y:0 h:footboardHeight w:footboardWidth];
                        footboard.anchorPoint = CGPointMake(0, 1);
                        [footboardsTheSameLine addObject:footboard];
                        [self addChild:footboard];
                        
                    }
                    
                    [tempCurrentXs addObject:[NSNumber numberWithInt:addX]];
                }
                x = randomCreateNumber - x;
                
            }
            
            currentXs = [NSMutableArray arrayWithObject:tempCurrentXs[0]];
            [footboards addObject:footboardsTheSameLine];
            
            fireBall = [FireBall spriteNodeWithTexture:((BitmapUtil *)[BitmapUtil sharedInstance]).fire_ball];
            fireBall.position = CGPointMake(0, self.frame.size.height);
            fireBall.size = ((BitmapUtil *)[BitmapUtil sharedInstance]).fire_ball_size;
            [fireBall setScreenWidth:self.frame.size.width];
//            [fireballs addObject:fireBall];
//            [self addChild:fireBall];
            
            drawCount = 0;
        }
    }
}

- (void)draw {
    bool isInjure = false;
    bool isDrawPlayer = true;
    
    firstBgHeight += SPEED;// 往上10
    secondBgHeight += SPEED;// 往上10
    
    NSLog(@"firstBgHeight%f secondBgHeight%f", firstBgHeight, secondBgHeight);
    
    if (firstBgHeight >= height) {
        firstBgHeight = -height;// 背景頂部到-430
    }
    if (secondBgHeight >= height) {
        secondBgHeight = -height;
    }
    
    backgroundNode.position = CGPointMake(backgroundNode.position.x, firstBgHeight);
    secondBackgroundNode.position = CGPointMake(secondBackgroundNode.position.x, secondBgHeight);
    
    float footboardByPlayerY = 0;
    
    int re = 0;
    
    playerStandOnFootboard = false;
    for (int j = 0; j < footboards.count; j++) {
        NSMutableArray* f = footboards[j];
        for (int k = 0; k < f.count; k++) {
            bool remove = false;
            Footboard* ene = f[k];
            int i = arc4random_uniform(20);

            ToolUtil* toolUtil = ene.tool;
            if (!toolUtil) {
                
                if (ene.toolNum == Footboard.NOTOOL) {
                    toolUtil = nil;
                } else if (ene.toolNum == Footboard.BOMB) {
                    toolUtil = [ToolUtil spriteNodeWithTexture:nil];
                    [toolUtil setToolUtilWithX:ene.position.x + ene.size.width / 2 Y:ene.position.y type:Footboard.BOMB];
                    //					toolUtil.draw(canvas, SPEED);
                } else if (ene.toolNum == Footboard.BOMB_EXPLODE) {
                    
                } else if (ene.toolNum == Footboard.EAT_MAN_TREE) {
                    toolUtil = [ToolUtil spriteNodeWithTexture:nil];
                    [toolUtil setToolUtilWithX:ene.position.x + ene.size.width / 2 Y:ene.position.y type:Footboard.EAT_MAN_TREE];
                } else {
                    toolUtil = [ToolUtil spriteNodeWithTexture:nil];
                    [toolUtil setToolUtilWithX:ene.position.x + ene.size.width / 2 Y:ene.position.y type:Footboard.CURE];
                    //					toolUtil.draw(canvas, SPEED);
                }
                
                if (toolUtil != nil) {
                    ene.tool = toolUtil;
                    toolUtil.zPosition = 1;
                    [self addChild:toolUtil];
                }
                
            }
            
            if ((ene.y) >= (int) (player.y + player.height)) {
                NSLog(@"b");
            }
            
            if (ene.y < player.y + player.height + 10) {
                NSLog(@"c");
            }
            
            if (ene.y >= player.y + player.height - 60) {
                NSLog(@"ene.y%f player.y + player.height%f ", ene.y , (player.y + player.height));
                NSLog(@"ene.y%f player.y + player.height + DOWNSPEED + SPEED %f", ene.y, (player.y + player.height + DOWNSPEED + SPEED));
            }
            
            //ene.y >= player.y + player.height -1 最後的-1是因為浮點數運算，有時會小個0.000X。
            if ((ene.x < player.x + player.width - SMOOTH_DEVIATION * 4)
                && (ene.x + footboardWidth > player.x + SMOOTH_DEVIATION * 4)
                && (ene.y <= player.y - player.height +1 && ene.y > player.y - player.height - DOWNSPEED - SPEED)) {
                
                if (toolUtil != nil
                    && (toolUtil.tool_x < player.x + player.width -SMOOTH_DEVIATION * 4)
                    && (toolUtil.tool_x + toolUtil.tool_width > player.x +SMOOTH_DEVIATION * 4)
                    && ene.toolNum != Footboard.BOMB_EXPLODE) {
                    
                    if (ene.toolNum == Footboard.BOMB) {
                        isInjure = true;
                        ene.toolNum = Footboard.BOMB_EXPLODE;
                        ene.tool = nil;
                        [toolUtil removeFromParent];
                        
                        ene.tool = toolExplodingUtil = [ToolUtil spriteNodeWithTexture:nil];
                        [toolExplodingUtil setToolUtilWithX:ene.position.x + ene.size.width/2 Y:ene.position.y type:Footboard.BOMB_EXPLODE];
                        [self addChild:toolExplodingUtil];
                        
                        life -= 60;
                        if (life < 0) {
                            life = 0;
                        }
                        redNode.hidden = false;
                    } else if (ene.toolNum == Footboard.CURE){
                        life = 90;
                        ene.toolNum = Footboard.NOTOOL;
                        ene.tool = nil;
                        [toolUtil removeFromParent];
                    } else if (ene.toolNum == Footboard.EAT_MAN_TREE){
                        [toolUtil doEat];
                        
                        if([toolUtil isEated]){
                            life -= 30;
                            if (life < 0) {
                                life = 0;
                            }
                            redNode.hidden = false;
                        }
                    }
                }
                
                if (playerDownOnFootBoard) {
                    whichFoorbar = 0;
                    playerWalkSpeed = 0;
                    if (ene.which == 5) {
                        isInjure = true;
                        life -= 30;
                        if (life < 0) {
                            life = 0;
                        }
               
                        redNode.hidden = false;
                    }
                    
                    if (ene.which == 1) {
                        whichFoorbar = 1;
                        // move = LEFT;
                        // move = 0;
                        playerWalkSpeed = commonUtil.SLIDERSPEED;
                    } else if (ene.which == 2) {
                        whichFoorbar = 2;
                        // move = RIGHT;
                        // move = 0;
                        playerWalkSpeed = -commonUtil.SLIDERSPEED;
                    }
                }
                
                playerStandOnFootboard = true;
                footboardByPlayerY = ene.y;
                player.y = footboardByPlayerY + player.height;
                // move=0;
                [ene setCount];
                playerDownOnFootBoard = false;
                // playerDownOnFootBoard = false;
            }
            // else{
            // playerStandOnFootboard=false;
            // }
            
            if(ene.toolNum == Footboard.BOMB_EXPLODE && toolExplodingUtil != nil){
                
                if (toolExplodingUtil.isExploding) {
                    toolUtil = nil;
                    
                    if (isDrawPlayer) {
                        isDrawPlayer = false;
                        [player drawDy:SPEED Dx:0 isInjure:isInjure];
                        isInjure = false;
                        [toolExplodingUtil draw:SPEED];
                    }
                    
                } else {
                    [toolExplodingUtil removeFromParent];
                    toolExplodingUtil = nil;
                    ene.toolNum = Footboard.NOTOOL;
                    ene.tool = nil;
                }
                
            }
            
            if (toolUtil != nil) {
                [toolUtil draw:SPEED];
            }
            
            if (ene.y > 0 - SPEED - footboardHeight && ene.bitmap != nil) {
                [ene drawDy:SPEED];
            } else {
                remove = true;
                re = k;
            }
            
            if (remove) {
                Footboard* footborad = [f objectAtIndex:re];
                [f removeObjectAtIndex:re];
                [footborad.tool removeFromParent];
                [footborad removeFromParent];
                k--;
            }
        }
    }
    
    if (topSpikedBar.position.y <= player.y) {
        isInjure = true;
        life = 0;
    }
    
    float playerDy=0;
    float playerDx=0;
    
    if (isDrawPlayer) {
        if (playerStandOnFootboard) {
            
            if (move == LEFT) {
                
                if (player.x <= 0) {
                    playerDy = SPEED;
                    playerDx = 0;
                    //						player.draw(canvas, SPEED, 0, isInjure);
                    move = 0;
                } else {
                    playerDy = SPEED;
                    playerDx = MOVESPEED + playerWalkSpeed;
                    //						player.draw(canvas, SPEED, MOVESPEED + playerMoveSpeed, isInjure);
                }
            } else if (move == RIGHT) {
                
                if (player.x + player.width >= width) {
                    playerDy = SPEED;
                    playerDx = 0;
                    //						player.draw(canvas, SPEED, 0, isInjure);
                    move = 0;
                } else {
                    playerDy = SPEED;
                    playerDx = -MOVESPEED + playerWalkSpeed;
                    //						player.draw(canvas, SPEED, -MOVESPEED + playerMoveSpeed, isInjure);
                }
                
            } else {
                
                if (whichFoorbar == 1) {
                    playerDy = SPEED;
                    playerDx = playerWalkSpeed;
                } else if (whichFoorbar == 2) {
                    playerDy = SPEED;
                    playerDx = playerWalkSpeed;
                } else {
                    playerDy = SPEED;
                    playerDx = 0;
                }
                
            }
            
        } else {
            
            if (move == LEFT) {
                
                if (player.x <= 0) {
                    playerDy = -DOWNSPEED;
                    playerDx = 0;
                    move = 0;
                } else {
                    playerDy = -DOWNSPEED;
                    playerDx = 8;
                }
                
            } else if (move == RIGHT) {
                
                if (player.x + player.width >= width) {
                    playerDy = -DOWNSPEED;
                    playerDx = 0;
                    
                    move = 0;
                } else {
                    
                    playerDy = -DOWNSPEED;
                    playerDx = -8;
                    
                }
                
            } else {
                
                playerDy = -DOWNSPEED;
                playerDx = 0;
                
            }
            
            playerDownOnFootBoard = true;
        }
    }
    
    [self checkPlayerMoved];
    
    NSMutableArray *outGoingFireballs = [NSMutableArray array];
    for (int i = 0; i < fireballs.count; i++) {
        FireBall* ball = fireballs[i];
        if (player.position.y < ball.position.y + ball.size.height
            && player.position.y > ball.position.y
            && player.position.x + player.size.width > ball.position.x + SMOOTH_DEVIATION
            && player.position.x < ball.position.x + ball.size.width - SMOOTH_DEVIATION) {
            isInjure = true;
            life = 0;
            if(isDrawPlayer){
                isDrawPlayer = false;
                [player drawDy:playerDy Dx:playerDx isInjure:isInjure];
                isInjure = false;
            }
        }
        [ball moveDy: (SPEED + SPEED) Dx:0];
        
        if (ball.position.y <= -ball.size.height) {
            [outGoingFireballs addObject:ball];
        }
    }
    
    for (int i = 0; i < outGoingFireballs.count; i++) {
        FireBall* ball = outGoingFireballs[i];
        [fireballs removeObject:ball];
        [ball removeFromParent];
    }
    
    if (isDrawPlayer) {
        [player drawDy:playerDy Dx:playerDx isInjure:isInjure];
    }
    
    if (life == 0 || player.y > height) {
        [self changeHpBar];
    } else if (life == 30) {
        [self changeHpBar];
    } else if (life == 60) {
        [self changeHpBar];
    } else {
        [self changeHpBar];
    }
    
    if (!gameSuccess) {
        [self setTimeTextures];
    }
    
    if (life == 0 || player.position.y < 0) {
        redNode.hidden = false;
        gameFlag = false;
        
        if (!isGameFinish) {
            isGameFinish = true;
            [self handler:0];
        }
    }
}

- (void)checkPlayerMoved {
    if(move == left){
        //        player.xScale = 1;
        //        player.position = CGPointMake(player.position.x - MOVESPEED, player.position.y);
        //        SKTexture * bitmap;
        
        //        if(!isMoving){
        //            isMoving = true;
        //            SKAction* move = [SKAction animateWithTextures:leftNsArray timePerFrame:0.2];
        //            [player runAction:[SKAction repeatActionForever:move]];
        //        }
        
    }else if(move == right){
        //        player.position = CGPointMake(player.position.x + MOVESPEED, player.position.y);
        //        SKTexture * bitmap;
        //        if(walkCount%2==0){
        //            bitmap = playerTextures[PLAYER_RIGHT_WALK02_INDEX];
        //        }else if(walkCount%3==0){
        //            bitmap = playerTextures[PLAYER_RIGHT_WALK01_INDEX];
        //        }else{
        //            bitmap = playerTextures[PLAYER_RIGHT_WALK03_INDEX];
        //        }
        //        player.texture = bitmap;
        //        walkCount++;
        //        player.xScale = -1;
        //        if(!isMoving){
        //            isMoving = true;
        //            SKAction* move = [SKAction animateWithTextures:rightNsArray timePerFrame:0.2];
        //            [player runAction:[SKAction repeatActionForever:move]];
        //        }
    }
}

- (void)changeHpBar {
    float hpBarWidth = self.frame.size.width / 3.0f * ((float)life / 90);
    float hpBarOffsetX = self.frame.size.width / 20 - hpBarWidth / 20;
    
    lifeNode.size = CGSizeMake(hpBarWidth, 26);
    
    lifeNode.anchorPoint = CGPointMake(0 , 0.5);
    
    
    if (life == 90) {
        lifeNode.position = CGPointMake(CGRectGetMaxX(self.frame) - hpBarWidth- hpBarOffsetX -5,
                                        CGRectGetMaxY(self.frame) - lifeNode.size.height / 2 - 45 - 50);
    } else {
        lifeNode.position = CGPointMake(lifeNode.position.x,
                                        CGRectGetMaxY(self.frame) - lifeNode.size.height / 2 - 45 - 50);
    }
    
    life_bgNode.size = CGSizeMake(self.frame.size.width / 3.0f + 6, 36);
    life_bgNode.position = CGPointMake(lifeNode.position.x - hpBarWidth / 30,
                                       CGRectGetMaxY(self.frame) - lifeNode.size.height / 2 - 45 - 50);
    life_bgNode.anchorPoint = CGPointMake(0, 0.5);
}

- (void)initTimeNode {
    int timeNodeWidthHeight = 30;
    
    self.timeMinuteTensDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
    
    self.timeMinuteTensDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
    
    self.timeMinuteTensDigital.position = CGPointMake(0 + self.timeMinuteTensDigital.size.width / 2, self.frame.size.height - self.timeMinuteTensDigital.size.height / 2 - 45 - 50);
    
    self.timeMinuteSingalDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
    
    self.timeMinuteSingalDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
    
    self.timeMinuteSingalDigital.position = CGPointMake(self.timeMinuteTensDigital.position.x+timeNodeWidthHeight, self.timeMinuteTensDigital.position.y);
    
    self.timeQmark = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][10]];
    
    self.timeQmark.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
    
    self.timeQmark.position = CGPointMake(self.timeMinuteTensDigital.position.x+timeNodeWidthHeight*2, self.timeMinuteTensDigital.position.y);
    
    self.timeScecondTensDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
    
    self.timeScecondTensDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
    
    self.timeScecondTensDigital.position = CGPointMake(self.timeMinuteTensDigital.position.x+timeNodeWidthHeight*3, self.timeMinuteTensDigital.position.y);
    
    self.timeSecondSingalDigital = [SKSpriteNode spriteNodeWithTexture:[TextureHelper timeTextures][0]];
    
    self.timeSecondSingalDigital.size = CGSizeMake(timeNodeWidthHeight, timeNodeWidthHeight);
    
    self.timeSecondSingalDigital.position = CGPointMake(self.timeMinuteTensDigital.position.x+timeNodeWidthHeight*4, self.timeMinuteTensDigital.position.y);
    
    [self addChild:self.timeMinuteTensDigital];
    [self addChild:self.timeMinuteSingalDigital];
    [self addChild:self.timeQmark];
    [self addChild:self.timeScecondTensDigital];
    [self addChild:self.timeSecondSingalDigital];
}

- (void)initReadyTimer {
    readyStep = 0;
    theReadyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                     target:self
                                                   selector:@selector(countReadyTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    [timers addObject:theReadyTimer];
}

- (void)countReadyTimer {
    if (readyStep == 0) {
        readyLabel.text = @"READY";
        readyLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    } else if(readyStep == 5) {
        readyLabel.hidden = YES;
        [theReadyTimer invalidate];
        readyFlag = false;
        return;
    } else {
        readyLabel.text = [NSString stringWithFormat:@"%d", 4 - readyStep];
        readyLabel.position = CGPointMake(self.frame.size.width/2 - readyLabel.frame.size.width/2, self.frame.size.height/2 );
    }
    
    readyStep++;
}

- (void)initGameTimer {
    
    theGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(countGameTime)
                                                  userInfo:nil
                                                   repeats:YES];
    [timers addObject:theGameTimer];
}

- (void)countGameTime {
    //    if(gameTime>3600){
    ////        theGameTimerLabel.text = @"";
    //        [theGameTimer invalidate];
    //        return;
    //    }
    
    if(!gameFlag || readyFlag){
        return;
    }
    
    count++;
    
    if(!gameSuccess){
        [self setTimeTextures];
    }
}

- (void)setTimeTextures {
    int showTime;
    if (level < INFINITY_LEVEL) {
        showTime = GAME_TIME - count;
    } else {
        showTime = count;
    }
    
    theGameTimerLabel.text = [NSString stringWithFormat:@"%d", showTime];
    
    //    SKTexture* timeMinuteHunDigitalTexture = [self getTimeTexture:count/60/10/10];
    SKTexture* timeMinuteTenDigitalTexture = [self getTimeTexture:showTime/60/10%10];
    SKTexture* timeMinuteSingleDigitalTexture = [self getTimeTexture:showTime/60%10];
    SKTexture* timeSecondTenDigitalTexture = [self getTimeTexture:showTime%60/10];
    SKTexture* timeSecondSingleDigitalTexture = [self getTimeTexture:showTime%60%10];
    
    //    [self.timeMinuteHunsDigital setTexture:timeMinuteHunDigitalTexture];
    [self.timeMinuteTensDigital setTexture:timeMinuteTenDigitalTexture];
    [self.timeMinuteSingalDigital setTexture:timeMinuteSingleDigitalTexture];
    [self.timeScecondTensDigital setTexture:timeSecondTenDigitalTexture];
    [self.timeSecondSingalDigital setTexture:timeSecondSingleDigitalTexture];
}

- (SKTexture *)getTimeTexture:(int)time {
    SKTexture* texture;
    switch (time) {
        case 0:
            texture = [TextureHelper timeTextures][0];
            break;
        case 1:
            texture = [TextureHelper timeTextures][1];
            break;
        case 2:
            texture = [TextureHelper timeTextures][2];
            break;
        case 3:
            texture = [TextureHelper timeTextures][3];
            break;
        case 4:
            texture = [TextureHelper timeTextures][4];
            break;
        case 5:
            texture = [TextureHelper timeTextures][5];
            break;
        case 6:
            texture = [TextureHelper timeTextures][6];
            break;
        case 7:
            texture = [TextureHelper timeTextures][7];
            break;
        case 8:
            texture = [TextureHelper timeTextures][8];
            break;
        case 9:
            texture = [TextureHelper timeTextures][9];
            break;
    }
    return texture;
}

+ (void)setNextBackground:(SKTexture*)nextBg {
    nextBackground = nextBg;
}

+ (int)LEFT {
    return LEFT;
}

+ (int)RIGHT {
    return RIGHT;
}

+ (int)gameFlag {
    return gameFlag;
}

+ (void)setGameFlag:(bool)_gameFlag {
    gameFlag = _gameFlag;
}

+ (int)FOOTBOARD_WIDTH_PERSENT {
    return FOOTBOARD_WIDTH_PERSENT;
}

@end
