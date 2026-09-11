package cintlex.oldlighter.mixin;

import cintlex.oldlighter.OldLighterAccessor;
import org.spongepowered.asm.mixin.Mixin;
import org.spongepowered.asm.mixin.injection.At;
import com.llamalad7.mixinextras.injector.wrapoperation.Operation;
import com.llamalad7.mixinextras.injector.wrapoperation.WrapOperation;
import com.llamalad7.mixinextras.sugar.Local;
import com.mojang.blaze3d.buffers.Std140Builder;
import com.mojang.blaze3d.buffers.Std140SizeCalculator;
import net.minecraft.client.renderer.Lightmap;
import net.minecraft.client.renderer.state.LightmapRenderState;
import org.joml.Vector3fc;

@Mixin(Lightmap.class)
public class LightmapUBO {

    @WrapOperation(
            method = "<clinit>",
            at = @At(value = "INVOKE", target = "Lcom/mojang/blaze3d/buffers/Std140SizeCalculator;get()I")
    )
    private static int oldlighter$extendubo(Std140SizeCalculator std, Operation<Integer> wrap) {
        return wrap.call(std.putFloat().putFloat());
    }

    @WrapOperation(
            method = "render",
            at = @At(
                    value = "INVOKE",
                    target = "Lcom/mojang/blaze3d/buffers/Std140Builder;putVec3(Lorg/joml/Vector3fc;)Lcom/mojang/blaze3d/buffers/Std140Builder;",
                    ordinal = 3
            )
    )
    private Std140Builder oldlighter$ambientfield(
            Std140Builder std, Vector3fc vec, Operation<Std140Builder> wrap,
            @Local(argsOnly = true) LightmapRenderState renderState
    ) {
        OldLighterAccessor accessor = (OldLighterAccessor) (Object) renderState;
        return std
                .putVec4(vec.x(), vec.y(), vec.z(), accessor.oldlighter$getamblightfactor())
                .putFloat(accessor.oldlighter$isirregularambient() ? 1.0F : 0.0F);
    }
}
