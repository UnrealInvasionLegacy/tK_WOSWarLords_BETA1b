class WOSWailLordIonEnergyProjectile extends WOSWailLordEnergyProjectile;

// camera shakes //
var() vector ShakeRotMag;           // how far to rot view
var() vector ShakeRotRate;          // how fast to rot view
var() float  ShakeRotTime;          // how much time to rot the instigator's view
var() vector ShakeOffsetMag;        // max view offset vertically
var() vector ShakeOffsetRate;       // how fast to offset view vertically
var() float  ShakeOffsetTime;       // how much time to offset view

function ShakeView()
{
    local Controller C;
    local PlayerController PC;
    local float Dist, Scale;

    for ( C=Level.ControllerList; C!=None; C=C.NextController )
    {
        PC = PlayerController(C);
        if ( PC != None && PC.ViewTarget != None )
        {
            Dist = VSize(Location - PC.ViewTarget.Location);
            if ( Dist < DamageRadius * 2.0)
            {
                if (Dist < DamageRadius)
                    Scale = 1.0;
                else
                    Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
            }
        }
    }
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    ShakeView();
    if ( Role == ROLE_Authority )
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );

    if ( EffectIsRelevant(Location,false) )
        Spawn(HitEffectClass,,, HitLocation + HitNormal*5, rotator(-HitNormal));

    PlaySound(sound'ONSBPSounds.ShockTank.ShockBallExplosion',SLOT_None,2.0,,800,1.1);

    Destroy();
}

defaultproperties
{
     ShakeRotMag=(Z=125.000000)
     ShakeRotRate=(Z=1750.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Z=5.000000)
     ShakeOffsetRate=(Z=100.000000)
     ShakeOffsetTime=4.000000
     AdrenDivisor=7
     MaxDrain=15.000000
     HitEffectClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordIonEnergyExplosion'
     PlasmaEffectClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordIonEnergyProjectileEmitter'
     Speed=1250.000000
     MaxSpeed=1500.000000
     Damage=75.000000
     DamageRadius=750.000000
     MyDamageType=Class'XWeapons.DamTypeIonBlast'
}
