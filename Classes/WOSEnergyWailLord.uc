//========================================================================
// WOSEnergyWailLord
// Energy WailLord written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSEnergyWailLord extends WOSWailLord;

var class<Projectile> MySuperProjectile;

//Fire new Energy bolts
function FireProjectile()
{
    local vector FireStart,X,Y,Z;
    local rotator FireRotation;
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
        FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,AimError);
        
        if (bAdvanced && r < SuperAttackChance)
        {
           Spawn(MySuperProjectile,,,FireStart,FireRotation);
           PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
        }
        else
        {
           Spawn(MyProjectile,,,FireStart,FireRotation);
           PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
        }
    }
}

defaultproperties
{
     MySuperProjectile=Class'tK_WOSWarLords_BETA1b.WOSWailLordIonEnergyProjectile'
     MyProjectile=Class'tK_WOSWarLords_BETA1b.WOSWailLordEnergyProjectile'
     bRocketLord=False
     bEnergyLord=True
     ResistanceValues(2)=0.100000
     ResistanceValues(3)=0.100000
     AttackPitch=1.525000
     PitchVariation=8.000000
     DodgeSkillAdjust=5.000000
     FireSound=Sound'ONSVehicleSounds-S.HoverBike.HoverBikeFire01'
     AmmunitionClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordEnergyAmmo'
     ScoringValue=10
     GroundSpeed=450.000000
     AirSpeed=550.000000
     Health=600
     Skins(0)=FinalBlend'tK_WOSWarLords_BETA1b.WarLord.WailLordFB1'
     Skins(1)=FinalBlend'tK_WOSWarLords_BETA1b.WarLord.WailLordFB1'
}
