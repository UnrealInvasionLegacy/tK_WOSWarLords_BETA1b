class WOSWailLordAdvancedRocketProjectile extends WOSWailLordRocketProjectile;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer)
    {
        SmokeTrail = Spawn(class'WOSWailLordAdvancedRocketTrailSmoke',self);
        Corona = Spawn(class'WOSWailLordAdvancedRocketCorona',self,,Location - 20 * Dir);
    }

    Dir = vector(Rotation);
    Velocity = speed * Dir;
    if (PhysicsVolume.bWaterVolume)
    {
        bHitWater = True;
        Velocity=0.6*Velocity;
    }

    SetTimer(0.1, true);

    Super(Projectile).PostBeginPlay();
}

simulated function Timer()
{
    local vector ForceDir;
    local float VelMag;

    if ( InitialDir == vect(0,0,0) )
        InitialDir = Normal(Velocity);
         
    Acceleration = vect(0,0,0);
    Super.Timer();
    if ( (Seeking != None) && (Seeking != Instigator) ) 
    {
        // Do normal guidance to target.
        ForceDir = Normal(Seeking.Location - Location);
        
        if( (ForceDir Dot InitialDir) > 0 )
        {
            VelMag = VSize(Velocity);
        
            // track vehicles better
            if ( Seeking.Physics == PHYS_Karma )
                ForceDir = Normal(ForceDir * 0.85 * VelMag + Velocity);
            else
                ForceDir = Normal(ForceDir * 0.65 * VelMag + Velocity);
            Velocity =  VelMag * ForceDir;
            Acceleration += 5 * ForceDir; 
        }
        // Update rocket so it faces in the direction its going.
        SetRotation(rotator(Velocity));
    }
}

defaultproperties
{
     AdrenDivisor=20
     MaxDrain=8.000000
     Speed=1250.000000
     MaxSpeed=1250.000000
     Damage=75.000000
     DrawScale=1.100000
}
