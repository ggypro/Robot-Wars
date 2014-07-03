//
//  TomBot.m
//  RobotWar
//
//  Created by Nurym Kudaibergen on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "TomBot.h"

typedef NS_ENUM(NSInteger, RobotState)
{
    RobotActionScanning,
    RobotActionFiring
};

@implementation TomBot
{
    int _currentRobotState;
    int lastTimeHit;
    int lastTimeSaw;
    int movedCounter;
    CGPoint positionOfEnemy;
}
- (void)run
{
    while (true)
    {
        if (_currentRobotState == RobotActionScanning)
        {
            if (movedCounter < 1)
            {
                CGFloat angleLastPosBot = [self angleBetweenHeadingDirectionAndWorldPosition:positionOfEnemy];
                if (!CGPointEqualToPoint(positionOfEnemy, ccp(0,0)))
                {
                    if (angleLastPosBot > 0)
                    {
                        [self turnRobotRight:abs(angleLastPosBot)];
                        
                    }
                    else if (angleLastPosBot < 0)
                    {
                        [self turnRobotLeft:abs(angleLastPosBot)];
                    }
                    [self moveAhead:100];
                }
                movedCounter++;
            }
        }
            if (_currentRobotState == RobotActionFiring)
            {
                if (self.currentTimestamp - lastTimeHit > 2.5f)
                {
                    [self cancelActiveAction];
                    _currentRobotState = RobotActionScanning;
                }
                else
                {
                    [self shoot];
                }
            }
        }
    }
- (void)scannedRobot:(Robot *)robot atPosition:(CGPoint)position
    {
        [self cancelActiveAction];
        positionOfEnemy = position;
        CGFloat angleBetweenGunAndEnemy = [self angleBetweenGunHeadingDirectionAndWorldPosition:position];
        if (angleBetweenGunAndEnemy > 0)
        {
            [self turnGunRight:abs(angleBetweenGunAndEnemy)];
            _currentRobotState = RobotActionFiring;
        }
        if (angleBetweenGunAndEnemy < 0)
        {
            [self turnGunLeft:abs(angleBetweenGunAndEnemy)];
            _currentRobotState = RobotActionFiring;
        }
        lastTimeHit = self.currentTimestamp;
        movedCounter = 0;
    }
    
    - (void)bulletHitEnemy:(Bullet *)bullet
    {
        lastTimeHit = self.currentTimestamp;
    }
    
    - (void)gotHit
    {
        [self moveAhead:20];
    }

@end

