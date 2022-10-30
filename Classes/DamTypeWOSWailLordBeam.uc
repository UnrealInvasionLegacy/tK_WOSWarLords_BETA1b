class DamTypeWOSWailLordBeam extends DamTypeShockBeam;

var array<string> DeathStrings;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    local int r;
    r = Rand(10);

    return Default.DeathStrings[r];
}

defaultproperties
{
     DeathStrings(0)="%o was fatally enlightened by a WailLord's laser beam."
     DeathStrings(1)="%o was dissected by a WailLord's laser scalpel."
     DeathStrings(2)="%o couldn't outrun a WailLord's beam of death."
     DeathStrings(3)="%o's brain was fried by a WailLord's laser."
     DeathStrings(4)="%o tried a WailLord's laser acupuncture. It worked."
     DeathStrings(5)="%o got knocked around by a WailLord's laser."
     DeathStrings(6)="A WailLord's energy beam cooked %o nicely."
     DeathStrings(7)="A WailLord's laser beam sliced and diced %o."
     DeathStrings(8)="A WailLord's laser made short work of %o."
     DeathStrings(9)="A WailLord's laser gave %o a lethal dose of radiation."
     bDetonatesGoop=False
}
