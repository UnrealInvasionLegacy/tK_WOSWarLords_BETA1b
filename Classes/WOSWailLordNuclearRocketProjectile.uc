class WOSWailLordNuclearRocketProjectile extends RedeemerProjectile;

var Emitter  newSmokeTrail;
var xEmitter xSmokeTrail;

simulated function PostBeginPlay()
{
    local vector Dir;

    if ( bDeleteMe || IsInState('Dying') )
        return;

    Dir = vector(Rotation);
    Velocity = speed * Dir;

    if ( Level.NetMode != NM_DedicatedServer)
    {
        newSmokeTrail = Spawn(class'WOSWailLordNuclearRocketTrail',self,,Location - 15 * Dir, Rotation);
        newSmokeTrail.SetBase(self);
        xSmokeTrail = Spawn(class'WOSWailLordAdvancedRocketTrailSmoke',self);
        xSmokeTrail.SetBase(self);
    }

    Super(Projectile).PostBeginPlay();
}

simulated function Destroyed()
{
    if ( newSmokeTrail != None )
        newSmokeTrail.Destroy();
    if ( xSmokeTrail != None )
        xSmokeTrail.Destroy();
    Super.Destroyed();
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	if ((Damage > 0) && ((EventInstigator == None) || (EventInstigator.Controller == None) || (Instigator == None) || (Instigator.Controller == None) || !EventInstigator.Controller.SameTeamAs(Instigator.Controller)) )
	{
		if ( (EventInstigator == None) || DamageType.Default.bVehicleHit || (DamageType == class'Crushed') )
			BlowUp(Location);
		else
		{
				if ( PlayerController(EventInstigator.Controller) != None ) {
					PlayerController(EventInstigator.Controller).PlayRewardAnnouncement('Denied',1, true);
		    	//BroadcastLocalizedMessage(class'InvasionMessages', 2, EventInstigator.Controller.PlayerReplicationInfo);
		    	EventInstigator.Controller.PlayerReplicationInfo.Score += 10;
		    }
  			Spawn(class'SmallRedeemerExplosion');
	    	SetCollision(false,false,false);
	    	HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer, Location);
		}
	}
	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);
}

state Dying
{
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType) {}
	function Timer() {}

    function BeginState()
    {
		bHidden = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		Spawn(class'IonCore',,, Location, Rotation);
		ShakeView();
		InitialState = 'Dying';
		if ( newSmokeTrail != None )
			newSmokeTrail.Destroy();
		if ( xSmokeTrail != None )
			xSmokeTrail.Destroy();
		SetTimer(0, false);
    }

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

Begin:
    PlaySound(sound'WeaponSounds.redeemer_explosionsound');
    HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer*0.125, Location);
    Sleep(0.5);
    HurtRadius(Damage, DamageRadius*0.300, MyDamageType, MomentumTransfer*0.300, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.475, MyDamageType, MomentumTransfer*0.475, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.650, MyDamageType, MomentumTransfer*0.650, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.825, MyDamageType, MomentumTransfer*0.825, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*1.000, MyDamageType, MomentumTransfer, Location);
    Destroy();
}

defaultproperties
{
     ExplosionEffectClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordNuclearRocketExplosion'
     Speed=1150.000000
     MaxSpeed=1150.000000
     Damage=40.000000
     DamageRadius=800.000000
     StaticMesh=StaticMesh'VMWeaponsSM.PlayerWeaponsGroup.bomberBomb'
     DrawScale=0.250000
}
