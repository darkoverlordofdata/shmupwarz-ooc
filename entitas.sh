#!/usr/bin/env bash

#
#   Set up project package with 'npm run entitas'' command
#
if [ ! -f ./package.json ]; then
    npm init -y
    sed -i "s/\"test\": \"echo \\\\\"Error: no test specified\\\\\" \&\& exit 1\"/\"entitas\": \"entitas\"/" package.json
fi
#
#   install local entitas-cli
#
if [ "" == "`npm list entitas-cli | grep 'entitas-cli'`" ]; then
    npm install entitas-cli --save-dev
fi
#
#   initialize entitas
#
if [ ! -f ./entitas.json ]; then
    npm run entitas -- init shmupwarz -t bin
fi


#
# create the schema & generate components
#
npm run entitas -- create -c Bounds radius:Double
npm run entitas -- create -c Bullet
npm run entitas -- create -c ColorTween redMin:Double redMax:Double redSpeed:Double greenMin:Double greenMax:Double greenSpeed:Double blueMin:Double blueMax:Double blueSpeed:Double alphaMin:Double alphaMax:Double alphaSpeed:Double  redAnimate:Bool greenAnimate:Bool blueAnimate:Bool alphaAnimate:Bool repeat:Bool
npm run entitas -- create -c Destroy
npm run entitas -- create -c Enemy
npm run entitas -- create -c Expires delay:Double
npm run entitas -- create -c Health health:Double maximumHealth:Double
npm run entitas -- create -c Layer ordinal:Int
npm run entitas -- create -c Player
npm run entitas -- create -c Position x:Double y:Double
npm run entitas -- create -c Resource path:String sprite:SdlTexture bgd:Bool
npm run entitas -- create -c ScaleTween min:Double max:Double speed:Double repeat:Bool active:Bool
npm run entitas -- create -c Scale x:Double y:Double
npm run entitas -- create -c Score value:Double
npm run entitas -- create -c SoundEffect effect:Int
npm run entitas -- create -c Text text:String sprite:SdlTexture
npm run entitas -- create -c Tint r:Int g:Int b:Int a:Int
npm run entitas -- create -c Velocity x:Double y:Double
npm run entitas -- create -s CollisionSystem ISetWorld IExecuteSystem IInitializeSystem
npm run entitas -- create -s ColorTweenSystem ISetWorld IExecuteSystem
npm run entitas -- create -s EntitySpawningTimerSystem ISetWorld IExecuteSystem IInitializeSystem
npm run entitas -- create -s ExpiringSystem ISetWorld IExecuteSystem
npm run entitas -- create -s HealthRenderSystem ISetWorld IExecuteSystem IInitializeSystem
npm run entitas -- create -s MovementSystem ISetWorld IExecuteSystem
npm run entitas -- create -s PlayerInputSystem ISetWorld IExecuteSystem IInitializeSystem
npm run entitas -- create -s RemoveOffscreenShipsSystem ISetWorld IExecuteSystem
npm run entitas -- create -s RenderPositionSystem ISetWorld IExecuteSystem
npm run entitas -- create -s SoundEffectSystem ISetWorld IExecuteSystem IInitializeSystem
npm run entitas -- create -s ScaleTweenSystem ISetWorld IExecuteSystem
npm run entitas -- create -s ViewManagerSystem ISetWorld IExecuteSystem
npm run entitas -- generate -p ooc -t source
