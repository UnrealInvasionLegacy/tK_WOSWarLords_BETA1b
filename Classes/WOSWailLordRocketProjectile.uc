class WOSWailLordRocketProjectile extends WarLordRocket;

var int AdrenDivisor;
var float MaxDrain;

simulated function PostBeginPlay()
{
    if ( Level.NetMode != NM_DedicatedServer)
    {
        SmokeTrail = Spawn(class'RocketTrailSmoke',self);
        Corona = Spawn(class'WOSWailLordRocketCorona',self,,Location - 20 * Dir);
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

simulated function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
    local actor Victims;
    local float damageScale, dist;
    local vector direction;
    local float r;
    local float AdrenDrain;
    local float DrainTemp;

    if ( bHurtEntry )
        return;

    bHurtEntry = true;
    foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
    {
        r = FRand();

        // don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
        if( (Victims != self) && (Hurtwall != Victims) && (Victims.Role == ROLE_Authority) && !Victims.IsA('FluidSurfaceInfo') )
        {
            direction = Victims.Location - HitLocation;
            dist = FMax(1,VSize(direction));
            direction = direction/dist;
            damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
            if ( Instigator == None || Instigator.Controller == None )
                Victims.SetDelayedDamageInstigatorController( InstigatorController );
            if ( Victims == LastTouched )
                LastTouched = None;
            Victims.TakeDamage
            (
                damageScale * DamageAmount,
                Instigator,
                Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * direction,
                (damageScale * Momentum * direction),
                DamageType
            );

            if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
                Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, Instigator.Controller, DamageType, Momentum, HitLocation);

            DrainTemp = FMax(1,((damageScale * DamageAmount) / AdrenDivisor ));
            AdrenDrain = -1 * FMin(MaxDrain,DrainTemp);
            
            if ( Pawn(Victims) != none && Pawn(Victims).Controller != none )
            {
            if ( (Pawn(Victims).Controller.Adrenaline > 300) && (Pawn(Victims).Controller.Adrenaline < 500) )
               AdrenDrain *= 1.25;

            if ( Pawn(Victims).Controller.Adrenaline > 500 )
               AdrenDrain *= 1.5;

            if ( Pawn(Victims).Controller.bGodMode )
               AdrenDrain *= 2;

            if ( Pawn(Victims).Controller.Adrenaline > 100+AdrenDrain || Pawn(Victims).Controller.bGodMode )
            {
               Pawn(Victims).Controller.AwardAdrenaline( AdrenDrain );
            }
            }


        }
    }
    if ( (LastTouched != None) && (LastTouched != self) && (LastTouched.Role == ROLE_Authority) && !LastTouched.IsA('FluidSurfaceInfo') )
    {
        Victims = LastTouched;
        LastTouched = None;
        direction = Victims.Location - HitLocation;
        dist = FMax(1,VSize(direction));
        direction = direction/dist;
        damageScale = FMax(Victims.CollisionRadius/(Victims.CollisionRadius + Victims.CollisionHeight),1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius));
        if ( Instigator == None || Instigator.Controller == None )
            Victims.SetDelayedDamageInstigatorController(InstigatorController);
        Victims.TakeDamage
        (
            damageScale * DamageAmount,
            Instigator,
            Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * direction,
            (damageScale * Momentum * direction),
            DamageType
        );
        if (Vehicle(Victims) != None && Vehicle(Victims).Health > 0)
            Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);

        DrainTemp = FMax(1,((damageScale * DamageAmount) / AdrenDivisor ));
        AdrenDrain = -1 * FMin(MaxDrain,DrainTemp);
        
        if ( Pawn(Victims) != none && Pawn(Victims).Controller != none )
        {
        if ( (Pawn(Victims).Controller.Adrenaline > 300) && (Pawn(Victims).Controller.Adrenaline < 500) )
           AdrenDrain *= 1.25;

        if ( Pawn(Victims).Controller.Adrenaline > 500 )
           AdrenDrain *= 1.5;

        if ( Pawn(Victims).Controller.bGodMode )
           AdrenDrain *= 2;

        if ( Pawn(Victims).Controller.Adrenaline > 100+AdrenDrain || Pawn(Victims).Controller.bGodMode )
        {
           Pawn(Victims).Controller.AwardAdrenaline( AdrenDrain );
        }
        }
    }

    bHurtEntry = false;
}

defaultproperties
{
     AdrenDivisor=30
     MaxDrain=5.000000
     MyDamageType=Class'tK_WOSWarLords_BETA1b.DamTypeWOSWailLordRocketProjectile'
}
