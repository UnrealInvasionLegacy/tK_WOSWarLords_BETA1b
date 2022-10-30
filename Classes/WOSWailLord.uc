//========================================================================
// WOSWailLord
// WOSWailLord written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSWailLord extends WarLord;

#EXEC OBJ LOAD FILE=Resources\WOSWarLordsTex1.utx PACKAGE=tK_WOSWarLords_BETA1b

var class<Projectile>             MyProjectile;
var bool                          bAdvanced, bRocketLord, bEnergyLord, bBeamLord, bArmorLord;
//var class<DamageType>             ResistedType0, ResistedType1, ResistedType2, ResistedType3, ResistedType4;
var array<float>                  ResistanceValues;
var float                         VorpalResistance, VorpalNegationChance, SuperAttackChance, AttackPitch, PitchVariation;
var int                           AimError;

//Altered footsteps to represent metallic boots
function Step()
{
    PlaySound(Sound'PlayerSounds.Final.FootstepRock', SLOT_Interact);
}

function bool SameSpeciesAs(Pawn P)
{
   return (Monster(P) != None);
}

//Fire new Rockets
function FireProjectile()
{
    local vector FireStart,X,Y,Z;
    local rotator ProjRot;
    local Projectile S;
    local float r;

    r = FRand();

    if ( Controller != None )
    {
        GetAxes(Rotation,X,Y,Z);
        FireStart = GetFireStart(X,Y,Z);
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
        ProjRot = Controller.AdjustAim(SavedFireProperties,FireStart,AimError);
        if ( bRocketDir )
            ProjRot.Yaw += 3072;
        else
            ProjRot.Yaw -= 3072;
        bRocketDir = !bRocketDir;
        S = Spawn(MyProjectile,,,FireStart,ProjRot);
        PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
    }
}

//Reduced damage from Vorpal weapons, specified other Damage Types
function TakeDamage(int Damage, Pawn instigatedBy, Vector hitLocation, Vector Momentum, class<DamageType> damageType)
{
  local float r;
  local bool bHasVorpal;
  //local int i;

  r = FRand();

#ifeq __RPG_PACKAGE_NAME MonsterAssaultRPG
  bHasVorpal = (instigatedBy != None && instigatedBy.Weapon.IsA('RW_Vorpal'));
#endif
#ifeq __RPG_PACKAGE_NAME TURRPG2
  bHasVorpal = (instigatedBy != None && class'WeaponModifier_Vorpal'.static.GetFor(instigatedBy.Weapon) != None);
#endif

  if ( bHasVorpal && (r < VorpalNegationChance) )
  {
     if(r < VorpalNegationChance)
     {
         PlaySound(sound'WeaponSounds.ArmorHit', SLOT_Pain,2*TransientSoundVolume,,400);
         return;
     }
     Damage *= (1 - VorpalResistance);
     Momentum *= (1 - VorpalResistance);
  }

  if ( DamageType.IsA('DamTypeMP5Bullet') )
  {
       Damage *= (1 - ResistanceValues[0]);
       Momentum *= (1 - ResistanceValues[0]);
  }

  if ( DamageType.IsA('DamTypeONSMine') )
  {
       Damage *= (1 - ResistanceValues[1]);
       Momentum *= (1 - ResistanceValues[1]);
  }

  if ( DamageType.IsA('DamTypeShockBeam') || DamageType.IsA('DamTypeShockBall') || DamageType.IsA('DamTypeShockCombo') )
  {
       Damage *= (1 - ResistanceValues[2]);
       Momentum *= (1 - ResistanceValues[2]);
  }

  if ( DamageType.IsA('DamTypeSniperShot') )
  {
       Damage *= (1 - ResistanceValues[3]);
       Momentum *= (1 - ResistanceValues[3]);
  }

  super.TakeDamage(Damage, instigatedBy, hitLocation, Momentum, damageType);
}

defaultproperties
{
     MyProjectile=Class'tK_WOSWarLords_BETA1b.WOSWailLordRocketProjectile'
     bRocketLord=True
     ResistanceValues(0)=0.100000
     ResistanceValues(1)=0.250000
     VorpalResistance=0.250000
     VorpalNegationChance=0.340000
     SuperAttackChance=0.060000
     AttackPitch=1.000000
     PitchVariation=4.000000
     aimerror=600
     AmmunitionClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordRocketAmmo'
     ScoringValue=12
     Skins(0)=FinalBlend'tK_WOSWarLords_BETA1b.WarLord.WailLordFB3'
     Skins(1)=FinalBlend'tK_WOSWarLords_BETA1b.WarLord.WailLordFB3'
}
