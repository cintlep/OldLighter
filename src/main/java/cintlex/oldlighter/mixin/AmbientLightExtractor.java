package cintlex.oldlighter.mixin;

import org.spongepowered.asm.mixin.Final;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Shadow;
import org.spongepowered.asm.mixin.injection.At;
import org.spongepowered.asm.mixin.injection.Inject;
import cintlex.oldlighter.OldLighterAccessor;
import net.minecraft.client.Minecraft;
import net.minecraft.client.multiplayer.ClientLevel;
import net.minecraft.client.renderer.LightmapRenderStateExtractor;
import net.minecraft.client.renderer.state.LightmapRenderState;
import net.minecraft.world.level.Level;
import org.spongepowered.asm.mixin.injection.callback.CallbackInfo;

@Mixin(LightmapRenderStateExtractor.class)
public abstract class AmbientLightExtractor {
    @Final @Shadow private Minecraft minecraft;

    @Inject(method = "extract", at = @At("TAIL"))
    private void oldlighter$storeamblightfactor(LightmapRenderState renderState, float partialTicks, CallbackInfo ci) {
        ClientLevel cl = this.minecraft.level;
        if (cl == null) return;
        OldLighterAccessor accessor = (OldLighterAccessor) (Object) renderState;
        accessor.oldlighter$setamblightfactor(cl.dimensionType().ambientLight());
        accessor.oldlighter$setirregularambient(cl.dimension() == Level.END);
    }
}