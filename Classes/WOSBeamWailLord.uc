//========================================================================
// WOSBeamWailLord
// Beam WailLord written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSBeamWailLord extends WOSWailLord;

var class<DamageType> DamageType;
var int DamageMin, DamageMax;
var float TraceRange, AttackMomentum;
var() class<ShockBeamEffect> BeamEffectClass;
var int AdrenDivisor;
var float MaxDrain;


function float MaxRange()
{
    if (Instigator.Region.Zone.bDistanceFog)
        TraceRange = FClamp(Instigator.Region.Zone.DistanceFogEnd, 8000, default.TraceRange);
    else
        TraceRange = default.TraceRange;

    return TraceRange;
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
    local ShockBeamEffect Beam;

    if (Weapon != None)
    {
        Beam = Weapon.Spawn(BeamEffectClass,,, Start, Dir);
        if (ReflectNum != 0) Beam.Instigator = None; // prevents client side repositioning of beam start
            Beam.AimAt(HitLocation, HitNormal);
    }
}

//Fire new Energy beams
function FireProjectile()
{
    local vector X,Y,Z;
    local float r;

    local Vector End, HitLocation, HitNormal, RefNormal;
    local Actor Other;
    local int Damage;
    local bool bDoReflect;
    local int ReflectNum;
    local vector Start;
    local Rotator Dir;

    local float AdrenDrain;
    local float DrainTemp;


    r = FRand();
    MaxRange();

    GetAxes(Rotation,X,Y,Z);
    Start = GetFireStart(X,Y,Z);

    if ( Controller != None )
    {
        if ( !SavedFireProperties.bInitialized )
        {
            SavedFireProperties.AmmoClass = MyAmmo.Class;
            SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
            SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
            SavedFireProperties.MaxRange = MyAmmo.MaxRange;
            SavedFireProperties.bTossed = MyAmmo.bTossed;
            SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
            SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
            SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
            SavedFireProperties.bInitialized = true;
        }
        Dir = Controller.AdjustAim(SavedFireProperties,Start,AimError);
        PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));

        ReflectNum = 0;
        while (true)
        {
            bDoReflect = false;
            X = Vector(Dir);
            End = Start + TraceRange * X;

            Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

            if ( Other != None && (Other != Instigator || ReflectNum > 0) )
            {
                if (Other.IsA('xPawn') && xPawn(Other).CheckReflect(HitLocation, RefNormal, DamageMin*0.25))
                {
                    bDoReflect = true;
                    HitNormal = Vect(0,0,0);
                }
                if ( !Other.bWorldGeometry )
                {
                    Damage = DamageMin;
                    if ( (DamageMin != DamageMax) && (FRand() > 0.5) )
                        Damage += Rand(1 + DamageMax - DamageMin);

                    // Update hit effect except for pawns (blood) other than vehicles.
                    if ( Other.IsA('Vehicle') || (!Other.IsA('Pawn') && !Other.IsA('HitScanBlockingVolume')) )
                        WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other, HitLocation, HitNormal);

                    Other.TakeDamage(Damage, Instigator, HitLocation, AttackMomentum*X, DamageType);

                    //Adrenaline drain handling
                    DrainTemp = FMax(1,(Damage / AdrenDivisor));
                    AdrenDrain = -1 * FMin(MaxDrain,DrainTemp);
                    
                    if ( Pawn(Other) != none && Pawn(Other).Controller != none )
                    {
                    if ( (Pawn(Other).Controller.Adrenaline > 300) && (Pawn(Other).Controller.Adrenaline < 500) )
                       AdrenDrain *= 1.25;
        
                    if ( Pawn(Other).Controller.Adrenaline > 500 )
                       AdrenDrain *= 1.5;
        
                    if ( Pawn(Other).Controller.bGodMode )
                       AdrenDrain *= 2;
        
                    if ( Pawn(Other).Controller.Adrenaline > 100+AdrenDrain || Pawn(Other).Controller.bGodMode )
                    {
                       Pawn(Other).Controller.AwardAdrenaline( AdrenDrain );
                    }
                    }

                    HitNormal = Vect(0,0,0);
                }
                else if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
                    WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
            }
            else
            {
                HitLocation = End;
                HitNormal = Normal(Start - End); //HitNormal = Vect(0,0,0);
                WeaponAttachment(Weapon.ThirdPersonActor).UpdateHit(Other,HitLocation,HitNormal);
            }

            SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, ReflectNum);

            if (bDoReflect && ++ReflectNum < 4)
            {
                //Log("reflecting off"@Other@Start@HitLocation);
                Start = HitLocation;
                Dir = Rotator(RefNormal); //Rotator( X - 2.0*RefNormal*(X dot RefNormal) );
            }
            else
            {
                break;
            }
        }//While

    }
}

defaultproperties
{
     DamageType=Class'tK_WOSWarLords_BETA1b.DamTypeWOSWailLordBeam'
     DamageMin=35
     DamageMax=40
     TraceRange=17000.000000
     AttackMomentum=30000.000000
     BeamEffectClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordBeamEmitter'
     AdrenDivisor=30
     MaxDrain=2.000000
     bRocketLord=False
     bBeamLord=True
     AttackPitch=5.325000
     PitchVariation=8.000000
     aimerror=850
     FireSound=SoundGroup'WeaponSounds.ShockRifle.ShockRifleFire'
     AmmunitionClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordBeamAmmo'
     GroundSpeed=375.000000
     AirSpeed=450.000000
     Health=450
     Skins(0)=FinalBlend'tK_WOSWarLords_BETA1b.WarLord.WailLordFB2'
     Skins(1)=FinalBlend'tK_WOSWarLords_BETA1b.WarLord.WailLordFB2'
}
