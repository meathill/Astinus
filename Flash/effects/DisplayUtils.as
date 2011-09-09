package effects {
  import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
  import flash.display.DisplayObject;
	/**
   * 存放视觉效果
   * @author Meathill
   */
  public class DisplayUtils {
    //=========================================================================
    // Class Constants
    //=========================================================================
    public static const GLOW:GlowFilter = new GlowFilter(0xff0000, .6, 8, 8);
		public static const SHADOW:DropShadowFilter = new DropShadowFilter(2, 45, 0x666666, .5, 2, 2);
    public static const BLUR:BlurFilter = new BlurFilter(2, 2);
    public static var COLORS:Vector.<uint> = new <uint>[0xFF7A00,
                                                        0x0B90C8,
                                                        0x6983ac,
                                                        0xfc6035,
                                                        0x985210,
                                                        0x6983ac,
                                                        0xC2D18E,
                                                        0x34de55,
                                                        0x25efab,
                                                        0x899C28,
                                                        0x92A3AB,
                                                        0x006E2E,
                                                        0xA6EEFC,
                                                        0xFECD33,
                                                        0xFC83D0,
                                                        0xE20806,
                                                        0x772100];
    //=========================================================================
    // Class Public Methods
    //=========================================================================
    public static function toggleMC(mc1:DisplayObject, mc2:DisplayObject, hide2:Boolean = true) {
      if (mc1.visible == mc2.visible) {
        mc1.visible = hide2;
        mc2.visible = !hide2;
      } else {
        mc1.visible = !mc1.visible;
        mc2.visible = !mc2.visible;
      }
    }
  }
}