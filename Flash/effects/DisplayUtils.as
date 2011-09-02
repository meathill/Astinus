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
		public static const SHADOW:DropShadowFilter = new DropShadowFilter(2, 45, 0x000000, .6, 2, 2);
    public static const BLUR:BlurFilter = new BlurFilter(2, 2);
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