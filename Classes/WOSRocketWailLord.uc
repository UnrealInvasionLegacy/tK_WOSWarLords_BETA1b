//========================================================================
// WOSRocketWailLord
// Rocket WailLord written by Wail of Suicide
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

class WOSRocketWailLord extends WOSWailLord;

var class<SeekingRocketProj> MySeekingProjectile;

//Fire new Rockets
function FireProjectile()
{
    local vector FireStart,X,Y,Z;
    local rotator ProjRot;
    local SeekingRocketProj S;
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

        if (bAdvanced && r < SuperAttackChance)
        {
           Spawn(MyProjectile,,,FireStart,ProjRot);
           PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
        }
        else
        {
           if ( bRocketDir )
            ProjRot.Yaw += 3072;
           else
            ProjRot.Yaw -= 3072;
           bRocketDir = !bRocketDir;
           S = Spawn(MySeekingProjectile,,,FireStart,ProjRot);
           S.Seeking = Controller.Enemy;
           PlaySound(FireSound,SLOT_Interact,,,,(AttackPitch+r/PitchVariation));
        }
    }
}

defaultproperties
{
     MySeekingProjectile=Class'tK_WOSWarLords_BETA1b.WOSWailLordRocketProjectile'
     MyProjectile=Class'tK_WOSWarLords_BETA1b.WOSWailLordNuclearRocketProjectile'
     AttackPitch=0.875000
}
