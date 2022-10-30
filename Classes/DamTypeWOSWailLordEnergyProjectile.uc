class DamTypeWOSWailLordEnergyProjectile extends DamTypeLinkPlasma;

var array<string> DeathStrings;

static function string DeathMessage(PlayerReplicationInfo Killer, PlayerReplicationInfo Victim)
{
    local int r;
    r = Rand(10);

    return Default.DeathStrings[r];
}

defaultproperties
{
     DeathStrings(0)="%o spent too long tanning under a WailLord's plasma blast."
     DeathStrings(1)="%o was deep-fried by a WailLord's plasma."
     DeathStrings(2)="%o got a little too close to a WailLord's superheated plasma."
     DeathStrings(3)="%o forgot to dodge a WailLord's plasma blast."
     DeathStrings(4)="%o's flesh was vaporized by a WailLord's plasma projection."
     DeathStrings(5)="%o "
     DeathStrings(6)="A WailLord's plasma turned %o into a pile of flaming chunks."
     DeathStrings(7)="A WailLord's plasma turned %o into red paste."
     DeathStrings(8)="A WailLord's plasma made explosive contact with %o's face."
     DeathStrings(9)="A WailLord's plasma introduced itself to %o."
     DeathString="%o was deep-fried by %k's plasma."
     bDetonatesGoop=False
     bSkeletize=True
     bLeaveBodyEffect=True
}
