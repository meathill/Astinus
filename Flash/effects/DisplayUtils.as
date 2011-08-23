package effects {
	import flash.filters.GlowFilter;
	import flash.filters.DropShadowFilter;
	/**
   * 存放视觉效果
   * @author Meathill
   */
  public class DisplayUtils {
    public static const GLOW:GlowFilter = new GlowFilter(0xff0000, .6, 8, 8);
		public static const SHADOW:DropShadowFilter = new DropShadowFilter(4, 45, 0x000000, .6);
  }
}