class WOSWailLordIonEnergyProjectileEmitter extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseDirectionAs=PTDU_Scale
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         ColorScale(0)=(Color=(G=192,R=192))
         ColorScale(1)=(RelativeTime=0.800000,Color=(B=212,G=64,R=212))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=212,G=64,R=212))
         CoordinateSystem=PTCS_Relative
         MaxParticles=2
         StartLocationOffset=(X=150.000000)
         StartSpinRange=(X=(Max=1.000000))
         StartSizeRange=(X=(Min=70.000000))
         InitialParticlesPerSecond=8000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'tK_WOSWarLords_BETA1b.WOSWailLordIonEnergyProjectileEmitter.SpriteEmitter8'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         UseDirectionAs=PTDU_Right
         UseColorScale=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(G=255,R=192))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,R=192))
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartLocationOffset=(X=50.000000)
         StartSizeRange=(X=(Min=-140.000000,Max=-140.000000),Y=(Min=53.000000,Max=61.000000))
         InitialParticlesPerSecond=500.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaHeadDesat'
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Max=10.000000))
         VelocityLossRange=(X=(Min=1.000000,Max=1.000000))
     End Object
     Emitters(1)=SpriteEmitter'tK_WOSWarLords_BETA1b.WOSWailLordIonEnergyProjectileEmitter.SpriteEmitter12'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter13
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         BlendBetweenSubdivisions=True
         ColorScale(1)=(RelativeTime=0.100000,Color=(B=255,G=128,R=224))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=251,R=208))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=20
         DetailMode=DM_High
         StartLocationOffset=(X=150.000000)
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.300000)
         SizeScale(1)=(RelativeTime=1.750000)
         StartSizeRange=(X=(Min=25.000000,Max=35.000000))
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.500000,Max=0.500000)
         StartVelocityRange=(X=(Min=-1750.000000,Max=-1750.000000))
         WarmupTicksPerSecond=1.000000
         RelativeWarmupTime=2.000000
     End Object
     Emitters(2)=SpriteEmitter'tK_WOSWarLords_BETA1b.WOSWailLordIonEnergyProjectileEmitter.SpriteEmitter13'

     bNoDelete=False
}
