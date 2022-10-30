class WOSWailLordAdvancedBeamEmitter extends WOSWailLordBeamEmitter;

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
    Spawn(class'WOSWailLordAdvancedBeamImpactFlare',,, EffectLoc, HitRot);
    Spawn(class'ShockImpactScorch',,, EffectLoc, Rotator(-HitNormal));
    Spawn(class'WOSWailLordAdvancedBeamExplosionCore',,, EffectLoc+HitNormal*8, HitRot);
}

defaultproperties
{
     MuzFlashClass=Class'tK_WOSWarLords_BETA1b.WOSWailLordAdvancedBeamMuzFlash'
     MuzFlash3Class=Class'tK_WOSWarLords_BETA1b.WOSWailLordAdvancedBeamMuzFlash3rd'
     Texture=ColorModifier'tK_WOSWarLords_BETA1b.WarLord.BeamTex1'
     Skins(0)=ColorModifier'tK_WOSWarLords_BETA1b.WarLord.BeamTex1'
}
