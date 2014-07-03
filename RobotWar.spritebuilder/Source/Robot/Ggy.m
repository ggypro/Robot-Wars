//
//  Ggy.m
//  RobotWar
//
//  Created by Bobby William Therry on 6/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Ggy.h"

typedef NS_ENUM(NSInteger, RobotChampion){
    RobotChampionStart,
    RobotChampionSearch,
    RobotChampionShoot,
    RobotChampionRun,
    Turning,
    RobotChampionGotHit
};


@implementation Ggy{
    RobotChampion _state;
    Robot *_catchRobot;
    CGPoint _thePosition;
    CGFloat _lastKnownPositionTimestamp;
    CGFloat _timeSinceLastEnemyHit;
    int counter;
}

-(void)run{
    while(true){
        if(_state == RobotChampionShoot){
            if((self.currentTimestamp - _lastKnownPositionTimestamp) > 1.f){
                _state = RobotChampionSearch;
            }else{
                CGFloat angle = [self angleBetweenGunHeadingDirectionAndWorldPosition:_thePosition];
                
                if(angle>=0){
                    [self turnGunRight:abs(angle)];
                }else {
                    [self turnGunLeft:abs(angle)];
                }
                [self shoot];
            }
        }
        
        if (_state == RobotChampionSearch){
            [self moveAhead:200];
        }
        
        if(_state == RobotChampionStart){
            [self moveBack:20];
        }
    }
}

-(void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position{
    if(_state != RobotChampionShoot || _state == RobotChampionSearch || _state == Turning){
        [self cancelActiveAction];
    }
    _catchRobot = robot;
    _thePosition = position;
    _lastKnownPositionTimestamp = self.currentTimestamp;
    _state = RobotChampionShoot;
}

-(void)hitWall:(RobotWallHitDirection)hitDirection hitAngle:(CGFloat)hitAngle{
    if(_state !=Turning){
        [self cancelActiveAction];
    }
    
    _state = Turning;
    
    switch (hitDirection) {
        case RobotWallHitDirectionFront:
            [self turnRobotRight:90];
            break;
        case RobotWallHitDirectionRear:
            [self turnRobotLeft:90];
            break;
        case RobotWallHitDirectionLeft:
            [self turnRobotRight:180];
            break;
        case RobotWallHitDirectionRight:
            [self turnRobotLeft:180];
            break;
        default:
            break;
    }
    
    _state = RobotChampionSearch;
}

-(void)bulletHitEnemy:(Bullet *)bullet{
    _timeSinceLastEnemyHit = self.currentTimestamp;
}

-(void)gotHit{
    /*if(_state != RobotChampionGotHit){
        [self cancelActiveAction];
    }
    
    _state = RobotChampionGotHit;
    int try =1;//+arc4random() %2;
    if (try==1){
        [self turnRobotRight:90];
        [self moveAhead:200];
    }else{
        [self turnRobotLeft:90];
        [self moveAhead:200];
    }
    _state = RobotChampionSearch;*/
    if(counter<10){
        counter++;
    }else{
        [self moveBack:100];
        counter=0;
    }
}
@end
