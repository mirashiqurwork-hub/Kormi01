package com.kormi.app.domain

import android.content.Context
import android.content.Intent
import com.kormi.app.data.local.converter.MachineType
import com.kormi.app.data.local.converter.MillShift
import com.kormi.app.data.local.entity.ProductionEntity

object ProductionShareFormatter {

    private val machineOrder = mapOf(
        MachineType.CD to 1,
        MachineType.BD to 2,
        MachineType.FD to 3,
        MachineType.SF to 4,
        MachineType.RF to 5,
        MachineType.LC to 6
    )

    fun formatShiftReport(
        companyName: String,
        date: String, // YYYY-MM-DD
        unit: String,
        shift: MillShift,
        entries: List<ProductionEntity>
    ): String {
        if (entries.isEmpty()) {
            return "$companyName\nDate: ${toDisplayDate(date)}\nUnit: $unit | Shift: ${shift.code}\n\nNo production data found for this shift."
        }

        val displayDate = toDisplayDate(date)
        val shiftLabel = when (shift) {
            MillShift.P_A -> "Morning"
            MillShift.P_B -> "Afternoon"
            MillShift.P_C -> "Night"
        }

        val incharge = entries.firstOrNull { it.inchargeName.isNotBlank() }?.inchargeName ?: "-"
        val sorted = entries.sortedBy { machineOrder[it.machineName] ?: 99 }

        val totalKg = sorted.sumOf { it.weightKg }
        val totalBags = sorted.sumOf { it.packingBags }

        val sb = StringBuilder()
        sb.appendLine(companyName)
        sb.appendLine("Date: $displayDate")
        sb.appendLine("Unit: $unit | Shift: ${shift.code} ($shiftLabel)")
        sb.appendLine()

        for (entry in sorted) {
            sb.appendLine("${entry.machineName.code} - ${formatKg(entry.weightKg)} Kg")
        }

        sb.appendLine()
        sb.appendLine("Total: ${formatKg(totalKg)} Kg")
        sb.appendLine("Packing Bags: $totalBags")
        sb.appendLine("Incharge: $incharge")

        return sb.toString().trim()
    }

    fun shareShiftReport(context: Context, reportText: String) {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, reportText)
        }
        context.startActivity(Intent.createChooser(intent, "Share Production Report"))
    }

    private fun toDisplayDate(date: String): String {
        // YYYY-MM-DD -> DD-MM-YYYY
        return try {
            val parts = date.split("-")
            if (parts.size == 3) "${parts[2]}-${parts[1]}-${parts[0]}" else date
        } catch (e: Exception) {
            date
        }
    }

    private fun formatKg(value: Double): String {
        return if (value % 1.0 == 0.0) {
            value.toInt().toString()
        } else {
            String.format("%.1f", value)
        }
    }
}
