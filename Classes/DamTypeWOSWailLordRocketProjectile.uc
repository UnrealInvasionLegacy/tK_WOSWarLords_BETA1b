class DamTypeWOSWailLordRocketProjectile extends DamTypeRocket;

var array<string> DeathStrings;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    local int r;
    r = Rand(10);

    return Default.DeathStrings[r];
}

defaultproperties
{
     DeathStrings(0)="%o inspected a WailLord's rocket too closely."
     DeathStrings(1)="%o was blown away by a WailLord's rocket."
     DeathStrings(2)="%o rode a WailLord's rocket to oblivion."
     DeathStrings(3)="%o was pumped full of WailLord rockets."
     DeathStrings(4)="%o was utterly destroyed by a WailLord's rocket."
     DeathStrings(5)="%o got singed by a WailLord's rocket."
     DeathStrings(6)="A WailLord's rocket turned %o into a pile of flaming chunks."
     DeathStrings(7)="A WailLord's rocket turned %o into red paste."
     DeathStrings(8)="A WailLord's rocket made explosive contact with %o's face."
     DeathStrings(9)="A WailLord's rocket introduced itself to %o."
     DeathString="%o inspected %k's rocket too closely."
     bDetonatesGoop=False
     VehicleMomentumScaling=1.000000
}
