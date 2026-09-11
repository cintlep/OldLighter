package cintlex.oldlighter.mixin;

import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.Unique;
import cintlex.oldlighter.OldLighterAccessor;
import net.minecraft.client.renderer.state.LightmapRenderState;

@Mixin(LightmapRenderState.class)
public class AmbientLight implements OldLighterAccessor {
    @Unique private float oldlighter$amblightfactor;
    @Unique private boolean oldlighter$irregularambient;

    @Override public float oldlighter$getamblightfactor() {
        return this.oldlighter$amblightfactor;
    }

    @Override public void oldlighter$setamblightfactor(float value) {
        this.oldlighter$amblightfactor = value;
    }

    @Override public boolean oldlighter$isirregularambient() {
        return this.oldlighter$irregularambient;
    }

    @Override public void oldlighter$setirregularambient(boolean value) {
        this.oldlighter$irregularambient = value;
    }
}
