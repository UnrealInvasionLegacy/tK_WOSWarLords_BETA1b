class WOSWailLordEnergyProjectile extends ONSMASPlasmaProjectile;

var int AdrenDivisor;
var float MaxDrain;

simulated function ProcessTouch (Actor Other, vector HitLocation)
{
    local Vector X, RefNormal, RefDir;

    if ( Instigator != None && (Other == Instigator) )
        return;

    if (Other == Owner) return;

    if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, Damage*0.25))
    {
        if (Role == ROLE_Authority)
        {
            X = Normal(Velocity);
            RefDir = X - 2.0*RefNormal*(X dot RefNormal);
            RefDir = RefNormal;
            Spawn(Class, Other,, HitLocation+RefDir*20, Rotator(RefDir));
        }
        Destroy();
    }
    else if ( !Other.IsA('Projectile') || Other.bProjTarget )
    {
        if ( Role == ROLE_Authority )
        {
            if ( Instigator == None || Instigator.Controller == None )
                Other.SetDelayedDamageInstigatorController( InstigatorController );

            Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), MyDamageType);
        }

        Explode(HitLocation, Normal(HitLocation-Other.Location));
    }
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

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    if ( EffectIsRelevant(Location,false) )
        Spawn(HitEffectClass,,, HitLocation + HitNormal*5, rotator(-HitNormal));

    PlaySound(sound'ONSBPSounds.ShockTank.ShockBallExplosion',SLOT_None,0.75,,300,1.0);

    Destroy();
}

defaultproperties
{
     AdrenDivisor=25
     MaxDrain=8.000000
     HitEffectClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordEnergyProjectileHitEmitter'
     Speed=1400.000000
     MaxSpeed=1800.000000
     Damage=70.000000
     DamageRadius=150.000000
     MomentumTransfer=40000.000000
     MyDamageType=Class'tK_WOSWarLords_BETA1b.DamTypeWOSWailLordEnergyProjectile'
     LifeSpan=10.000000
}
