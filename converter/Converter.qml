import QtQuick
import Quickshell
import qs.Services

Item {
    id: root

    property var pluginService: null
    property string trigger: "`"
    signal itemsChanged()

    readonly property var conversionFactors: ({
        // Distance (m)
        "μm": 0.000001, "nm": 0.000000001, "mm": 0.001, "cm": 0.01, "dm": 0.1, "m": 1, "km": 1000,
        "in": 0.0254, "ft": 0.3048, "yd": 0.9144, "mi": 1609.34, "nmi": 1852,
        "thou": 0.0000254, "mil": 0.0000254,
        // Weight (kg)
        "ng": 0.000000000001, "μg": 0.000000001, "mg": 0.000001, "g": 0.001, "kg": 1, "t": 1000, "mt": 1000,
        "gr": 0.00006479891, "dr": 0.0017718, "oz": 0.0283495, "lb": 0.453592, "st": 6.35029, "ton": 907.185,
        "cwt": 50.8023,
        // Speed (m/s)
        "m/s": 1, "km/h": 0.277778, "mph": 0.44704, "knot": 0.51444, "ft/s": 0.3048, "in/s": 0.0254,
        // Volume (L)
        "ul": 0.000001, "ml": 0.001, "l": 1, "cl": 0.01, "dl": 0.1,
        "tsp": 0.00492892, "tbsp": 0.0147868, "fl oz": 0.0295735, "cup": 0.236588, "pint": 0.473176, "pt": 0.473176,
        "quart": 0.946353, "qt": 0.946353, "gal": 3.78541, "barrel": 119.240,
        // Area (m²)
        "mm2": 0.000001, "cm2": 0.0001, "m2": 1, "km2": 1000000,
        "in2": 0.00064516, "ft2": 0.092903, "yd2": 0.836127, "mi2": 2589988,
        "acre": 4046.86, "hectare": 10000,
        // Energy (Joules)
        "j": 1, "kj": 1000, "cal": 4.184, "kcal": 4184, "wh": 3600, "kwh": 3600000, "ev": 1.602e-19
    })

    readonly property var unitCategories: ({
        distance: ["μm", "nm", "mm", "cm", "dm", "m", "km", "in", "ft", "yd", "mi", "nmi", "thou", "mil"],
        weight: ["ng", "μg", "mg", "g", "kg", "t", "mt", "gr", "dr", "oz", "lb", "st", "ton", "cwt"],
        speed: ["m/s", "km/h", "mph", "knot", "ft/s", "in/s"],
        volume: ["ul", "ml", "l", "cl", "dl", "tsp", "tbsp", "fl oz", "cup", "pint", "pt", "quart", "qt", "gal", "barrel"],
        area: ["mm2", "cm2", "m2", "km2", "in2", "ft2", "yd2", "mi2", "acre", "hectare"],
        energy: ["j", "kj", "cal", "kcal", "wh", "kwh", "ev"],
        temperature: ["c", "f", "k"],
        color: ["rgb", "hex", "hsv", "hsl"]
    })

    Component.onCompleted: {
        console.info("Converter: Plugin loaded")
        if (pluginService) {
            trigger = pluginService.loadPluginData("converter", "trigger", "`")
        }
    }

    function getCategory(unit) {
        unit = unit.toLowerCase().trim()
        for (let category in unitCategories) {
            if (unitCategories[category].indexOf(unit) !== -1) {
                return category
            }
        }
        return null
    }

    function convertValue(value, fromUnit, toUnit, category) {
        if (category === "temperature") {
            return convertTemperature(value, fromUnit, toUnit)
        }
        const siValue = value * conversionFactors[fromUnit]
        return siValue / conversionFactors[toUnit]
    }

    function convertTemperature(value, fromUnit, toUnit) {
        fromUnit = fromUnit.toLowerCase().trim()
        toUnit = toUnit.toLowerCase().trim()
        
        let celsius = value
        if (fromUnit === "f") {
            celsius = (value - 32) * 5 / 9
        } else if (fromUnit === "k") {
            celsius = value - 273.15
        }
        
        if (toUnit === "f") {
            return celsius * 9 / 5 + 32
        } else if (toUnit === "k") {
            return celsius + 273.15
        }
        return celsius
    }

    function formatResult(value) {
        if (value === null || value === undefined) return "0"
        const absValue = Math.abs(value)
        let decimals = 4
        
        if (absValue >= 1000000) decimals = 0
        else if (absValue >= 1000) decimals = 1
        else if (absValue >= 1) decimals = 2
        else if (absValue >= 0.01) decimals = 4
        else decimals = 6
        
        return parseFloat(value.toFixed(decimals))
    }

    function getItems(query) {
        console.log("Converter query:", query)
        
        if (!query || query.trim().length === 0) {
            return [{
                name: "Converter",
                icon: "material:compare_arrows",
                comment: "Format: 5m-km or #fff-rgb",
                categories: ["Converter"]
            }]
        }

        const trimmed = query.trim()
        
        // Look for hyphen separator
        if (!trimmed.includes("-")) {
            return [{
                name: trimmed,
                icon: "material:compare_arrows",
                comment: "Add hyphen and target unit (e.g., 5m-km)",
                categories: ["Converter"]
            }]
        }

        const parts = trimmed.split("-")
        if (parts.length < 2) {
            return [{
                name: trimmed,
                icon: "material:compare_arrows",
                comment: "Enter target unit after hyphen",
                categories: ["Converter"]
            }]
        }

        const source = parts[0].trim()
        const target = parts.slice(1).join("-").toLowerCase().trim()

        // Parse value and unit
        const valueMatch = source.match(/^([\d.]+)(.+)$/)
        if (!valueMatch) {
            return [{
                name: trimmed,
                icon: "material:error",
                comment: "Invalid format",
                categories: ["Converter"]
            }]
        }

        const value = parseFloat(valueMatch[1])
        const sourceUnit = valueMatch[2].toLowerCase().trim()

        if (isNaN(value)) {
            return [{
                name: trimmed,
                icon: "material:error",
                comment: "Invalid number",
                categories: ["Converter"]
            }]
        }

        const sourceCategory = getCategory(sourceUnit)
        const targetCategory = getCategory(target)

        if (!sourceCategory) {
            return [{
                name: trimmed,
                icon: "material:error",
                comment: `Unknown unit: ${sourceUnit}`,
                categories: ["Converter"]
            }]
        }

        if (!targetCategory) {
            return [{
                name: trimmed,
                icon: "material:error",
                comment: `Unknown unit: ${target}`,
                categories: ["Converter"]
            }]
        }

        if (sourceCategory !== targetCategory) {
            return [{
                name: trimmed,
                icon: "material:error",
                comment: `Can't convert ${sourceCategory} to ${targetCategory}`,
                categories: ["Converter"]
            }]
        }

        try {
            const result = convertValue(value, sourceUnit, target, sourceCategory)
            const formattedResult = formatResult(result)

            return [{
                name: `${value}${sourceUnit} → ${formattedResult}${target}`,
                icon: "material:check_circle",
                comment: sourceCategory,
                action: `copy:${formattedResult}${target}`,
                categories: ["Converter"]
            }]
        } catch (e) {
            console.log("Converter error:", e)
            return [{
                name: trimmed,
                icon: "material:error",
                comment: e.toString(),
                categories: ["Converter"]
            }]
        }
    }

    function executeItem(item) {
        if (!item || !item.action) {
            console.warn("Converter: Invalid item or action")
            return
        }

        const actionParts = item.action.split(":")
        const actionType = actionParts[0]
        const actionData = actionParts.slice(1).join(":")

        if (actionType === "copy") {
            Quickshell.execDetached(["dms", "clipboard", "copy", actionData])
            if (typeof ToastService !== "undefined") {
                ToastService.showInfo("Converter", "Copied: " + actionData)
            }
        }
    }

    onTriggerChanged: {
        if (pluginService) {
            pluginService.savePluginData("converter", "trigger", trigger)
        }
    }
}
