class WOSWailLordBeamEmitter extends ShockBeamEffect;

var class<xEmitter> BeamCircleEmitterClass;

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
    Spawn(class'WOSWailLordBeamImpactFlare',,, EffectLoc, HitRot);
    Spawn(class'ShockImpactScorch',,, EffectLoc, Rotator(-HitNormal));
    Spawn(class'WOSWailLordBeamExplosionCore',,, EffectLoc+HitNormal*8, HitRot);
}

simulated function bool CheckMaxEffectDistance(PlayerController P, vector SpawnLocation)
{
    return !P.BeyondViewDistance(SpawnLocation,3000);
}

simulated function SpawnEffects()
{
    local xEmitter Circles;
    local int CircleParticles;
    local xWeaponAttachment Attachment;

    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
            if ( (Instigator.Weapon != None) && (Instigator.Weapon.Instigator == Instigator) )
                SetLocation(Instigator.Weapon.GetEffectStart());
            else
                SetLocation(Instigator.Location);
            Spawn(MuzFlashClass,,, Location);
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
                SetLocation(Attachment.GetTipLocation());
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0); 
            Spawn(MuzFlash3Class);
        }
    }

    if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
        SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);
    
    CircleParticles = VSize(Location - mSpawnVecA) / 30;

	if(Level.bDropDetail)
		CircleParticles /= 2;

	if(Level.DetailMode == DM_Low)
		CircleParticles /= 2;

	if(CircleParticles >= 2)
	{

		Circles = Spawn(BeamCircleEmitterClass,,, (Location + mSpawnVecA) / 2, Rotator(Location - mSpawnVecA));

		if(Circles != None)
		{
			Circles.mPosDev.X = 100 * (VSize(Location - mSpawnVecA) / 200);
			Circles.mStartParticles = CircleParticles;
			Circles.mRegen = false;
		}
	}
}

defaultproperties
{
     CoilClass=None
     MuzFlashClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordBeamMuzFlash'
     MuzFlash3Class=Class'tK_WOSWarLords_BETA1b.WOSWailLordBeamMuzFlash3rd'
     Texture=ColorModifier'tK_WOSWarLords_BETA1b.WarLord.BeamTex0'
     Skins(0)=ColorModifier'tK_WOSWarLords_BETA1b.WarLord.BeamTex0'
}
