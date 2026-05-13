import QtQuick
import qs.Common
import qs.Modules.Plugins
import qs.Widgets

PluginSettings {
    id: root
    pluginId: "converter"

    StyledText {
        width: parent.width
        text: "Converter"
        font.pixelSize: Theme.fontSizeLarge
        font.weight: Font.Bold
        color: Theme.surfaceText
    }

    StyledText {
        width: parent.width
        text: "Universal converter for distance, weight, temperature, speed, volume, area, energy, and color."
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
        bottomPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "Distance"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "μm, nm, mm, cm, dm, m, km, in, ft, yd, mi, nmi, thou, mil"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Weight"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "ng, μg, mg, g, kg, t, mt, gr, dr, oz, lb, st, ton, cwt"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Temperature"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "c, f, k"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Speed"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "m/s, km/h, mph, knot, ft/s, in/s"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Volume"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "ul, ml, l, cl, dl, tsp, tbsp, fl oz, cup, pint, pt, quart, qt, gal, barrel"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Area"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "mm2, cm2, m2, km2, in2, ft2, yd2, mi2, acre, hectare"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Energy"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "j, kj, cal, kcal, wh, kwh, ev"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Color"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "hex, rgb, hsv, hsl"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.surfaceVariantText
        wrapMode: Text.WordWrap
    }

    StyledText {
        width: parent.width
        text: "Usage Examples"
        font.pixelSize: Theme.fontSizeMedium
        font.weight: Font.SemiBold
        color: Theme.surfaceText
        topPadding: Theme.spacingM
    }

    StyledText {
        width: parent.width
        text: "`5m-km"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.primary
        wrapMode: Text.WordWrap
        font.family: "monospace"
    }

    StyledText {
        width: parent.width
        text: "`32f-c"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.primary
        wrapMode: Text.WordWrap
        font.family: "monospace"
    }

    StyledText {
        width: parent.width
        text: "`100lb-kg"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.primary
        wrapMode: Text.WordWrap
        font.family: "monospace"
    }

    StyledText {
        width: parent.width
        text: "`#ff00ff-rgb"
        font.pixelSize: Theme.fontSizeSmall
        color: Theme.primary
        wrapMode: Text.WordWrap
        font.family: "monospace"
    }
}
