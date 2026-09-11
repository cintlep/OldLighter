<img width="1280" height="480" alt="banner" src="https://github.com/user-attachments/assets/d0b75a7e-05ed-420e-a235-ca486fe32bf7" />

Mojang rewrote the lightmap engine to use UBO's in 1.21.9, switching from a fixed cubic curve light renderer to a more customizable tint based model. While this is great for creators, it unfortunately changed the default color and brightness curve in vanilla we've been used to since Beta 1.8.

This mod uses a hybrid approach to restore the old lightmap without breaking the new features introduced with it. It nearly 1:1 replicates the old curve and colors, while keeping end flashes and data driven light tinting from the new engine. It is also compatible with all major optimization mods like Sodium.

This mod does NOT reintroduce MC-225088, nor does it break night vision, wither dimming, nether & end colors, etc. Those have been properly fixed or reimplemented in this.
